return {
    "nvimtools/none-ls.nvim",
    config = function()
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        require("null-ls").setup({
            -- you can reuse a shared lspconfig on_attach callback here
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                            -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.diagnostics.erb_lint,
                null_ls.builtins.diagnostics.rubocop,
                null_ls.builtins.formatting.rubocop,
                null_ls.builtins.diagnostics.pylint,
                null_ls.builtins.formatting.black,
            },
        })

        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
    on_attach = function(_, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(client)
                    return client.name == "null-ls"
                end
            })
            print("File formatted")
        end, { desc = 'Format current buffer with LSP' })
    end

}
