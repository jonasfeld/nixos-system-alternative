{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraLuaConfig = /* lua */ ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      vim.o.number = true
      vim.o.relativenumber = true

      vim.o.scrolloff = 8

      vim.o.signcolumn = 'yes:1'

      vim.o.ignorecase = true
      vim.o.smartcase = true

      vim.o.tabstop = 4
      vim.o.softtabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true

      vim.o.termguicolors = true

      vim.o.mouse = 'a'
      vim.o.mousemoveevent = true

      vim.o.conceallevel = 1
      vim.o.concealcursor = 'cnv'

      vim.o.clipboard = 'unnamedplus'

      vim.o.showmode = false

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    '';

    extraConfig = /* vim */ ''
      set whichwrap+=<,>,h,l,[,]
      autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
      autocmd vimenter * hi NormalNC guibg=NONE ctermbg=NONE
      autocmd vimenter * hi LineNr guibg=NONE ctermbg=NONE
    '';

    plugins = with pkgs.vimPlugins; [
      (import ./battery-nvim.nix { inherit pkgs; }).package
      cmp_luasnip
      cmp-nvim-lsp
      markdown-preview-nvim
      neodev-nvim
      nvim-web-devicons
      playground
      telescope-file-browser-nvim

      {
        plugin = import ./base16-nvim/package-patched.nix { inherit pkgs; };
        type = "lua";
        config = import ./base16-nvim/lua-config.nix { inherit config; };
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = ''require("Comment").setup {}'';
      }

      /* {
        plugin = copilot-lua;
        type = "lua";
        config = ''require("copilot").setup {}'';
      } */

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require("gitsigns").setup {}'';
      }

      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = ''require("guess-indent").setup {}'';
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = import ./lualine-nvim.nix { inherit config; };
      }

      {
        plugin = luasnip;
        type = "lua";
        config = builtins.readFile ./luasnip.lua;
      }

      {
        plugin = lsp-zero-nvim;
        type = "lua";
        config = builtins.readFile ./lsp-zero-nvim.lua;
      }

      {
        plugin = nvim-cmp;
	      type = "lua";
        config = builtins.readFile ./nvim-cmp.lua;
      }

      {
        plugin = nvim-lspconfig;
        # type = "lua";
        # config = builtins.readFile ./nvim-lspconfig.lua;
      }
      
      {
        plugin = nvim-navic;
        type = "lua";
        config = builtins.readFile ./nvim-navic.lua;
      }
      
      {
        plugin = import ./nvim-treesitter/package-withPlugins.nix { inherit pkgs; };
        type = "lua";
        config = builtins.readFile ./nvim-treesitter/lua-config.lua;
      }
      
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''require("nvim-autopairs").setup {}'';
      }

      {
        plugin = obsidian-nvim;
        type = "lua";
        config = builtins.readFile ./obsidian-nvim.lua;
      }

      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./oil-nvim.lua;
      }

      {
        plugin = rainbow-delimiters-nvim;
        type = "lua";
        config = builtins.readFile ./rainbow-delimiters-nvim.lua;
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./telescope-nvim.lua;
      }

      {
        plugin = vimtex;
      }

      {
        plugin = harpoon;
        type = "lua";
        config = ''
          local mark = require("harpoon.mark")
          local ui = require("harpoon.ui")

          vim.keymap.set("n", "<leader>a", mark.add_file)
          vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)
          vim.keymap.set("n", "<leader>j", function() ui.nav_file(1) end)
          vim.keymap.set("n", "<leader>k", function() ui.nav_file(2) end)
          vim.keymap.set("n", "<leader>l", function() ui.nav_file(3) end)

          require("harpoon").setup({
              -- enable tabline with harpoon marks
              tabline = true,
              tabline_prefix = "    ",
              tabline_suffix = "    ",
              })
        '';
      }

      {
        plugin = lazy-lsp-nvim;
        type = "lua";
        config = ''
          require("lazy-lsp").setup {
             excluded_servers = {
               "ccls",                            -- prefer clangd
                 "denols",                          -- prefer eslint and tsserver
                 "docker_compose_language_service", -- yamlls should be enough?
                 "flow",                            -- prefer eslint and tsserver
                 "ltex",                            -- grammar tool using too much CPU
                 "quick_lint_js",                   -- prefer eslint and tsserver
                 "rnix",                            -- archived on Jan 25, 2024
                 "scry",                            -- archived on Jun 1, 2023
                 "tailwindcss",                     -- associates with too many filetypes
                 "sourcekit",                       -- spams log
                 "nixd",                            -- prefer nil
             },
             preferred_servers = {
               -- markdown = {},
               python = { "pyright", "ruff_lsp" },
             },
             prefer_local = true, -- Prefer locally installed servers over nix-shell
             -- Default config passed to all servers to specify on_attach callback and other options.
             default_config = {
               flags = {
                 debounce_text_changes = 150,
               },
               -- on_attach = on_attach,
               -- capabilities = capabilities,
             },
             -- Override config for specific servers that will passed down to lspconfig setup.
             -- Note that the default_config will be merged with this specific configuration so you don't need to specify everything twice.
             configs = {
               lua_ls = {
                 settings = {
                   Lua = {
                     diagnostics = {
                       -- Get the language server to recognize the `vim` global
                         globals = { "vim" },
                     },
                   },
                 },
               },
             },
            }
        '';
      }
    ];

    extraPackages = with pkgs; [
      # Misc
      acpi
      fd
      nodePackages.nodejs
      ripgrep
    ];
  };  
}
