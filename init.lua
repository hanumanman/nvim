-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps,
-- basic autocmds, custom commands
-- ============================================================
do
  vim.loader.enable()

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  vim.g.have_nerd_font = true

  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.tabstop = 2
  vim.o.shiftwidth = 2
  vim.o.expandtab = true
  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.o.cursorline = true
  vim.opt.fillchars = { eob = ' ' }
  vim.o.signcolumn = 'yes:2'
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.inccommand = 'split'
  vim.o.scrolloff = 10
  vim.o.confirm = true

  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)

  vim.diagnostic.config({ virtual_text = true })

  local map = vim.keymap.set

  map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
  map('n', '<cr>', 'o<Esc>', { desc = 'Insert newline below' })
  map('n', 'Y', 'y$', { desc = 'Yank to end of line' })
  map('i', '<C-v>', '<cmd>norm p<cr>', { desc = 'Paste in insert mode' })

  map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
  map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
  map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
  map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })

  map('n', '<C-i>', '<cmd>b#<cr>', { desc = 'Switch to last buffer' })
  map('n', '<leader>x', '<cmd>bdelete<cr>', { desc = 'Close current buffer' })
  map('n', 'H', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
  map('n', 'L', '<cmd>bnext<cr>', { desc = 'Next buffer' })

  map('n', '<leader>bc', function()
    local cur = vim.api.nvim_get_current_buf()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if b ~= cur and vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
        vim.api.nvim_buf_delete(b, { force = false })
      end
    end
  end, { desc = 'Close other buffers' })

  map('n', 'yie', 'ggyG', { desc = 'Yank entire file' })
  map('n', 'vie', 'ggVG', { desc = 'Select entire file' })
  map('n', 'cie', 'ggcG', { desc = 'Change entire file' })
  map('n', 'die', 'ggdG', { desc = 'Delete entire file' })

  map('n', '<leader>n', '*N', { desc = 'Search word under cursor and go back' })
  map('v', '<leader>n', function()
    vim.cmd('normal! "zy')
    local text = vim.fn.escape(vim.fn.getreg('z'), '/\\^$*+?()[]{}|')
    vim.fn.setreg('/', text)
    vim.o.hlsearch = true
    vim.fn.setreg('z', '')
  end, { desc = 'Search selected text' })

  map('n', '<leader>j', function()
    vim.cmd('terminal')
    vim.cmd('startinsert')
  end, { desc = 'Open terminal' })
  map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Highlight on yank
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('yank-highlight', { clear = true }),
    callback = function()
      vim.hl.on_yank({ timeout = 100 })
    end,
  })

  -- Filetype for JSON / .env
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.json', '.env.*' },
    callback = function(ev)
      if ev.match:match('%.json$') then
        vim.bo.filetype = 'jsonc'
      elseif ev.match:match('%.env%..*$') then
        vim.bo.filetype = 'sh'
      end
    end,
  })

  -- Relative numbers toggling
  local nr_group = vim.api.nvim_create_augroup('numbertoggle', {})
  vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
    group = nr_group,
    callback = function()
      if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
        vim.o.relativenumber = true
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
    group = nr_group,
    callback = function()
      if vim.o.nu then
        vim.o.relativenumber = false
        vim.cmd.redraw()
      end
    end,
  })

  -- Disable auto-comment on new line
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('NoAutoComment', { clear = true }),
    pattern = '*',
    callback = function()
      vim.opt_local.formatoptions:remove({ 'r', 'o' })
    end,
  })

  -- LSPSortImports command and global
  local function lsp_sort_imports(callback)
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients == 0 then
      vim.notify('No LSP client attached', vim.log.levels.WARN)
      if callback then
        callback()
      end
      return
    end
    local handlers = {
      python = function()
        local ruff
        for _, c in ipairs(clients) do
          if c.name == 'ruff' then
            ruff = c
            break
          end
        end
        if not ruff then
          vim.notify('Ruff LSP not found', vim.log.levels.WARN)
          if callback then
            callback()
          end
          return
        end
        ruff:request('workspace/executeCommand', {
          command = 'ruff.applyOrganizeImports',
          arguments = { { uri = vim.uri_from_bufnr(bufnr), version = 1 } },
        }, function(err)
          if err then
            vim.notify('Error: ' .. vim.inspect(err), vim.log.levels.ERROR)
          end
          if callback then
            callback()
          end
        end)
      end,
      typescript = function()
        require('vtsls').commands.organize_imports(bufnr, function()
          if callback then
            callback()
          end
        end, function(err)
          vim.notify('Error: ' .. vim.inspect(err), vim.log.levels.ERROR)
          if callback then
            callback()
          end
        end)
      end,
    }
    handlers.typescriptreact = handlers.typescript
    handlers.javascript = handlers.typescript
    handlers.javascriptreact = handlers.typescript
    local handler = handlers[ft]
    if handler then
      handler()
    else
      vim.notify('LSPSortImports not supported for: ' .. ft, vim.log.levels.INFO)
      if callback then
        callback()
      end
    end
  end
  _G.lsp_sort_imports = lsp_sort_imports
  vim.api.nvim_create_user_command('LSPSortImports', function()
    lsp_sort_imports()
  end, {
    desc = 'Sort/organize imports using LSP',
  })

  -- Format + sort imports + save
  map('n', '<leader>f', function()
    _G.lsp_sort_imports(function()
      require('conform').format({ async = false, timeout_ms = 5000, lsp_format = 'fallback' })
      vim.cmd('w')
    end)
  end, { desc = 'Sort imports, format, and save' })
end

--- Helper to build github URLs
---@param repo string
---@return string
local function gh(repo)
  return 'https://github.com/' .. repo
end

-- ============================================================
-- SECTION 2: BUILD HOOKS
-- Run build steps after plugin install/update
-- ============================================================
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local output = (result.stderr or '') ~= '' and result.stderr or result.stdout or 'No output'
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has('win32') ~= 1 and vim.fn.executable('make') == 1 then
          run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then
          vim.cmd.packadd('nvim-treesitter')
        end
        vim.cmd('TSUpdate')
        return
      end
    end,
  })
end

-- ============================================================
-- SECTION 3: COLORSCHEME
-- Custom "sage" theme
-- ============================================================
do
  require('sage')

  local set_hl = vim.api.nvim_set_hl
  set_hl(0, 'Pmenu', { bg = 'none' })
  set_hl(0, 'BlinkCmpMenu', { bg = 'none' })
  set_hl(0, 'StatusLine', { bg = 'none' })
  set_hl(0, 'Float', { bg = 'none' })
  set_hl(0, 'NormalFloat', { bg = 'none' })
  set_hl(0, 'FloatTitle', { bg = 'none' })
  set_hl(0, 'FloatBorder', { bg = 'none' })
  set_hl(0, 'BlinkCmpBorder', { bg = 'none' })
  set_hl(0, 'BlinkCmpMenuBorder', { bg = 'none' })
  set_hl(0, 'LspReferenceText', { bg = 'none' })
  set_hl(0, 'BlinkCmpDoc', { bg = 'none' })
  set_hl(0, 'BlinkCmpDocBorder', { bg = 'none' })
end

-- ============================================================
-- SECTION 4: CORE UX PLUGINS
-- flash, which-key, mini modules, nvim-surround
-- ============================================================
do
  vim.pack.add({ gh('folke/flash.nvim') })
  require('flash').setup({})
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader><leader>', function()
    require('flash').treesitter()
  end, { desc = 'Flash Treesitter' })
  vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
    require('flash').jump()
  end, { desc = 'Flash jump' })

  vim.pack.add({ gh('folke/which-key.nvim') })
  require('which-key').setup({
    preset = 'helix',
    icons = { mappings = true },
  })

  vim.pack.add({ gh('nvim-mini/mini.nvim') })
  require('mini.cursorword').setup({})
  require('mini.icons').setup({})
  require('mini.ai').setup({ n_lines = 500 })
  require('mini.bufremove').setup({})
  require('mini.indentscope').setup({})
  require('mini.tabline').setup({})

  vim.pack.add({ { src = gh('kylechui/nvim-surround'), version = vim.version.range('^3.0.0') } })
  require('nvim-surround').setup({})
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- fzf-lua, oil.nvim
-- ============================================================
do
  vim.pack.add({ gh('ibhagwan/fzf-lua') })

  local fzf_ok, fzf = pcall(require, 'fzf-lua')
  if fzf_ok then
    fzf.setup({
      lsp = {
        code_actions = {
          trim_prompt = 'Apply suggested fix: ',
          previewer = false,
        },
      },
    })

    fzf.register_ui_select(function(fzf_opts, _)
      if fzf_opts.kind == 'codeaction' then
        return vim.tbl_deep_extend('force', fzf_opts, {
          winopts = { height = 0.5, width = 0.4, row = 0.5, col = 0.5 },
        })
      end
      return fzf_opts
    end)

    local orig_code_action = vim.lsp.buf.code_action
    vim.lsp.buf.code_action = function(opts)
      opts = opts or {}
      opts.filter = function(action)
        local title = action.title or ''
        return not (title:match('%(disabled%)') or action.disabled)
      end
      return orig_code_action(opts)
    end

    vim.keymap.set('n', '<leader>s', function()
      fzf.files()
    end, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>dw', function()
      fzf.live_grep()
    end, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>do', function()
      fzf.oldfiles({ cwd_only = true })
    end, { desc = 'Recent files' })
    vim.keymap.set('n', '<leader>/', function()
      fzf.blines()
    end, { desc = 'Search buffer' })
    vim.keymap.set('n', '<leader>da', function()
      fzf.resume()
    end, { desc = 'Resume search' })
    vim.keymap.set('n', '<leader>dh', function()
      fzf.command_history()
    end, { desc = 'Command history' })
  end

  vim.pack.add({ gh('stevearc/oil.nvim') })
  require('oil').setup({
    float = {
      padding = 7,
      max_width = 0,
      max_height = 0,
      border = 'rounded',
      win_options = { winblend = 0 },
    },
  })
  vim.keymap.set('n', '-', '<cmd>Oil --float<cr>', { desc = 'Open Oil' })
end

-- ============================================================
-- SECTION 6: LSP
-- LSP config, mason, servers, keymaps
-- ============================================================
do
  vim.pack.add({ gh('j-hui/fidget.nvim') })
  require('fidget').setup({})

  vim.pack.add({
    gh('neovim/nvim-lspconfig'),
    gh('mason-org/mason.nvim'),
    gh('mason-org/mason-lspconfig.nvim'),
    gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
    gh('b0o/SchemaStore.nvim'),
  })

  require('mason').setup({})

  local servers = {
    vtsls = {
      settings = {
        vtsls = { autoUseWorkspaceTsdk = true },
        javascript = { preferences = { importModuleSpecifier = 'non-relative' } },
        typescript = {
          preferences = { importModuleSpecifier = 'non-relative' },
          suggest = { includeCompletionsForImportStatements = true },
        },
      },
    },
    ruff = {
      init_options = {
        settings = { organizeImports = true, logLevel = 'debug' },
      },
    },
    jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          format = { enable = true },
          validate = { enable = true },
        },
      },
    },
    lua_ls = {
      settings = {
        Lua = { completion = { callSnippet = 'Replace' } },
      },
    },
    cssls = {
      settings = {
        css = { validate = true, lint = { unknownAtRules = 'ignore' } },
        less = { validate = true, lint = { unknownAtRules = 'ignore' } },
        scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
      },
    },
  }

  local ensure_installed = {
    'vtsls',
    'lua-language-server',
    'json-lsp',
    'css-lsp',
    'ruff',
    'emmet-language-server',
    'eslint-lsp',
    'tailwindcss-language-server',
    'svelte-language-server',
    'ty',
    'stylua',
    'shfmt',
    'prettierd',
  }
  require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

  require('mason-lspconfig').setup()

  -- LSP Attach keymaps
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('K', function()
        vim.lsp.buf.hover({ border = 'rounded' })
      end, 'Hover')
      map('<leader>e', function()
        vim.diagnostic.open_float({ border = 'rounded' })
      end, 'Diagnostic float')
      map('<leader>q', function()
        require('fzf-lua').diagnostics_document()
      end, 'Document diagnostics')
      map('gd', function()
        require('fzf-lua').lsp_definitions()
      end, '[G]oto [D]efinition')
      map('gr', function()
        require('fzf-lua').lsp_references()
      end, '[G]oto [R]eferences')
      map('<leader>D', function()
        require('fzf-lua').lsp_typedefs()
      end, 'Type Definition')
      map('<leader>ds', function()
        require('fzf-lua').lsp_document_symbols()
      end, 'Document symbols')
      map('<leader>r', vim.lsp.buf.rename, 'Rename')
      map('<leader>ca', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Apply blink.cmp capabilities to all servers
  local ok, blink = pcall(require, 'blink.cmp')
  if ok then
    vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities() })
  end

  -- Register server configs
  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end

  -- vtsls plugin
  vim.pack.add({ gh('yioneko/nvim-vtsls') })
  vim.keymap.set('n', '<leader>ia', function()
    require('vtsls').commands.add_missing_imports()
  end, { desc = 'Add all missing imports' })
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim
-- ============================================================
do
  vim.pack.add({ gh('stevearc/conform.nvim') })
  require('conform').setup({
    format_on_save = {
      timeout_ms = 5000,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      markdown = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      sh = { 'shfmt' },
    },
  })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp, LuaSnip, friendly-snippets, custom snippets,
-- supermaven
-- ============================================================
do
  vim.pack.add({
    { src = gh('L3MON4D3/LuaSnip'), version = vim.version.range('2.*') },
    gh('rafamadriz/friendly-snippets'),
    { src = gh('saghen/blink.cmp'), version = vim.version.range('1.*') },
  })

  require('luasnip').setup({})
  require('luasnip.loaders.from_vscode').lazy_load()
  require('snippets')

  require('blink.cmp').setup({
    keymap = { preset = 'enter' },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      accept = { auto_brackets = { enabled = false } },
      menu = { border = 'rounded' },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        window = { border = 'rounded' },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true, window = { border = 'rounded' } },
  })

  vim.pack.add({ gh('supermaven-inc/supermaven-nvim') })
  require('supermaven-nvim').setup({
    color = { suggestion_color = '#8B949E', cterm = 244 },
    keymaps = { accept_suggestion = '<C-l>', accept_word = '<C-j>' },
  })
end

-- ============================================================
-- SECTION 9: TREESITTER
-- nvim-treesitter, ts-autotag, Comment, context-commentstring,
-- treesitter-context
-- ============================================================
do
  vim.pack.add({
    { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
    gh('windwp/nvim-ts-autotag'),
    gh('numToStr/Comment.nvim'),
    gh('JoosepAlviste/nvim-ts-context-commentstring'),
    gh('nvim-treesitter/nvim-treesitter-context'),
  })

  local install_dir = vim.fn.stdpath('data') .. '/site'
  vim.opt.runtimepath:prepend(install_dir)

  require('nvim-treesitter').setup({ install_dir = install_dir })
  require('nvim-treesitter').install({ 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'typescript', 'html', 'css' })

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)
      if not lang then
        return
      end
      if vim.treesitter.language.add(lang) then
        vim.treesitter.start()
      end
    end,
  })

  require('nvim-ts-autotag').setup({
    opts = { enable_close = true, enable_rename = true, enable_close_on_slash = true },
  })

  require('Comment').setup({
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  })

  vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true })
  vim.api.nvim_set_hl(0, 'TreesitterContextLineNumberBottom', { underline = true })

  require('treesitter-context').setup({ enable = false })
  vim.keymap.set('n', '<leader>tc', '<cmd>TSContextToggle<cr>', { desc = 'Toggle treesitter context' })
end

-- ============================================================
-- SECTION 10: GIT
-- gitsigns, lazygit, diffview
-- ============================================================
do
  vim.pack.add({
    gh('lewis6991/gitsigns.nvim'),
    gh('kdheepak/lazygit.nvim'),
    gh('sindrets/diffview.nvim'),
    gh('nvim-lua/plenary.nvim'),
  })

  require('gitsigns').setup({
    signcolumn = true,
    preview_config = {
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
      border = 'rounded',
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'Next git change' })
      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, { desc = 'Previous git change' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>hb', gs.blame_line, { desc = 'Blame line' })
      map({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>')
    end,
  })

  vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

  require('diffview').setup({})
end

-- ============================================================
-- SECTION 11: UI & QoL
-- lualine, alpha dashboard, colorizer, render-markdown,
-- lazydev, luvit-meta
-- ============================================================
do
  -- Statusline
  vim.pack.add({ gh('nvim-lualine/lualine.nvim') })
  local function git_username()
    local handle = io.popen('git config user.name')
    if not handle then
      return ''
    end
    local result = handle:read('*a')
    handle:close()
    if result == '' then
      return ''
    end
    return '󰊢 ' .. (result:gsub('^%s*(.-)%s*$', '%1'))
  end
  require('lualine').setup({
    options = {
      theme = 'auto',
      disabled_filetypes = { 'neo-tree', 'alpha', 'trouble', 'Avante', 'AvanteInput' },
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { {
        'mode',
        fmt = function(str)
          return str:sub(1, 1)
        end,
      } },
      lualine_b = { { git_username }, 'branch', 'diff', 'diagnostics' },
      lualine_x = { 'filetype' },
    },
  })

  -- Dashboard
  vim.pack.add({ gh('goolord/alpha-nvim') })
  local dashboard = require('alpha.themes.dashboard')
  local logo = [[
       /|､       
      (°､ ｡ 7    
      |､  ~ヽ    
      じしf_,)〳    ]]
  dashboard.section.header.val = vim.split(logo, '\n')
  dashboard.section.buttons.val = {
    dashboard.button('o', ' ' .. ' Recent files', '<cmd>lua require("fzf-lua").oldfiles({ cwd_only = true }) <cr>'),
    dashboard.button('s', ' ' .. ' Find file', '<cmd>lua require("fzf-lua").files() <cr>'),
    dashboard.button('v', ' ' .. ' Grep text', '<cmd>lua require("fzf-lua").live_grep() <cr>'),
    dashboard.button('q', ' ' .. ' Quit', '<cmd> qa <cr>'),
  }
  for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = 'AlphaButtons'
    button.opts.hl_shortcut = 'AlphaShortcut'
  end
  dashboard.section.header.opts.hl = 'AlphaHeader'
  dashboard.section.buttons.opts.hl = 'AlphaButtons'
  dashboard.section.footer.opts.hl = 'AlphaFooter'
  dashboard.opts.layout[1].val = 8
  local version = vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch
  dashboard.section.footer.val = 'Neovim ' .. version
  require('alpha').setup(dashboard.opts)

  -- Colorizer
  vim.pack.add({ gh('catgoose/nvim-colorizer.lua') })
  require('colorizer').setup({
    options = {
      parsers = {
        tailwind = { enable = true, lsp = true, update_names = true, mode = 'virtualtext' },
      },
    },
  })

  -- Render markdown
  vim.pack.add({ gh('MeanderingProgrammer/render-markdown.nvim') })
  require('render-markdown').setup({ enabled = false })
  vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle Render Markdown' })

  -- lazydev for Neovim Lua development
  vim.pack.add({ gh('folke/lazydev.nvim'), gh('Bilal2453/luvit-meta') })
  require('lazydev').setup({
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
  })
end

-- vim: ts=2 sts=2 sw=2 et
