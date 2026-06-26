-- Swift LSP configuration
vim.lsp.enable("sourcekit")

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP Actions",
  callback = function(args)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
  end,
})
