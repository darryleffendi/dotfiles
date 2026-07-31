#!/usr/bin/env bash
# Generate `.groovy-lsp-classpath` for a Gradle Groovy project so that
# groovy-language-server (groovyls) can resolve imports and support
# go-to-declaration / go-to-implementation.
#
# Usage:
#   gen-groovy-classpath.sh [PROJECT_DIR]
# PROJECT_DIR defaults to the current directory. It must contain a Gradle
# wrapper (gradlew) or `gradle` must be on PATH.
#
# JDK selection: old Gradle wrappers cannot run on new JDKs (e.g. Gradle 6.x
# rejects Java 17/21). If the active JDK is too new for the project's Gradle,
# this script auto-selects a compatible JDK from SDKMAN. Set
# GROOVY_LSP_JAVA_HOME to force a specific JDK and skip auto-selection.
set -euo pipefail

PROJECT_DIR="${1:-$PWD}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INIT_SCRIPT="$SCRIPT_DIR/../gradle/groovy-lsp-classpath.init.gradle"

if [ ! -f "$INIT_SCRIPT" ]; then
  echo "gen-groovy-classpath: init script not found at $INIT_SCRIPT" >&2
  exit 1
fi

cd "$PROJECT_DIR"

# --- Java version of a given JAVA_HOME (or PATH java). Prints major, e.g. 21.
java_major() {
  local jh="${1:-}" javabin
  if [ -n "$jh" ] && [ -x "$jh/bin/java" ]; then javabin="$jh/bin/java"; else javabin="java"; fi
  command -v "$javabin" >/dev/null 2>&1 || return 1
  local v
  v="$("$javabin" -version 2>&1 | head -1 | grep -oE '[0-9]+(\.[0-9]+)+' | head -1)" || return 1
  local maj="${v%%.*}"
  # legacy "1.8.0" style -> 8
  if [ "$maj" = "1" ]; then maj="${v#1.}"; maj="${maj%%.*}"; fi
  echo "$maj"
}

# --- Max Java major a given Gradle major.minor can run on (conservative).
gradle_max_java() {
  case "$1" in
    5.*) echo 11 ;;
    6.*) echo 15 ;;
    7.*) echo 19 ;;
    *)   echo 99 ;;   # 8+ (and unknown newer) run on anything installed
  esac
}

# --- Highest SDKMAN JDK whose major is <= $1. Prints its path, or nothing.
pick_sdkman_java() {
  local max="$1" base="$HOME/.sdkman/candidates/java" best="" bestmaj=0
  [ -d "$base" ] || return 0
  local d name maj
  for d in "$base"/*/; do
    name="$(basename "$d")"
    [ "$name" = "current" ] && continue
    maj="${name%%.*}"
    [ "$maj" = "1" ] && maj=8
    case "$maj" in ''|*[!0-9]*) continue ;; esac
    if [ "$maj" -le "$max" ] && [ "$maj" -gt "$bestmaj" ]; then
      bestmaj="$maj"; best="${d%/}"
    fi
  done
  [ -n "$best" ] && echo "$best"
}

if [ -n "${GROOVY_LSP_JAVA_HOME:-}" ]; then
  export JAVA_HOME="$GROOVY_LSP_JAVA_HOME"
  echo "gen-groovy-classpath: using GROOVY_LSP_JAVA_HOME=$JAVA_HOME" >&2
else
  GRADLE_VER="$(grep -oE 'gradle-[0-9]+\.[0-9]+(\.[0-9]+)?' gradle/wrapper/gradle-wrapper.properties 2>/dev/null | head -1 | sed 's/gradle-//')"
  if [ -n "$GRADLE_VER" ]; then
    MAX_JAVA="$(gradle_max_java "$GRADLE_VER")"
    CUR_JAVA="$(java_major "${JAVA_HOME:-}" || echo 0)"
    if [ "${CUR_JAVA:-0}" -gt "$MAX_JAVA" ] || [ "${CUR_JAVA:-0}" -eq 0 ]; then
      COMPAT="$(pick_sdkman_java "$MAX_JAVA")"
      if [ -n "$COMPAT" ]; then
        export JAVA_HOME="$COMPAT"
        echo "gen-groovy-classpath: Gradle $GRADLE_VER needs Java <=$MAX_JAVA; using $JAVA_HOME" >&2
      else
        echo "gen-groovy-classpath: WARNING - Gradle $GRADLE_VER needs Java <=$MAX_JAVA but no compatible SDKMAN JDK found; trying anyway" >&2
      fi
    fi
  fi
fi

if [ -x "./gradlew" ]; then
  GRADLE=("./gradlew")
elif command -v gradle >/dev/null 2>&1; then
  GRADLE=("gradle")
else
  echo "gen-groovy-classpath: no ./gradlew and no gradle on PATH in $PROJECT_DIR" >&2
  exit 1
fi

echo "gen-groovy-classpath: resolving dependencies for $PROJECT_DIR (this may take a while)..." >&2
"${GRADLE[@]}" -I "$INIT_SCRIPT" printGroovyLspClasspath -q

CP_FILE="$PROJECT_DIR/.groovy-lsp-classpath"
if [ -s "$CP_FILE" ]; then
  echo "gen-groovy-classpath: done -> $CP_FILE ($(wc -l < "$CP_FILE" | tr -d ' ') jars)" >&2
else
  echo "gen-groovy-classpath: WARNING - no jars written to $CP_FILE" >&2
  exit 1
fi
