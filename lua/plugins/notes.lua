---@type LazySpec
return {
  'epwalsh/obsidian.nvim',
  enabled = true,
  ft = 'markdown',
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    'BufReadPre ' .. vim.fn.expand '~/Notes/**/*.md',
    'BufNewFile ' .. vim.fn.expand '~/Notes/**/*.md',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>md', ':ObsidianToday<cr>', desc = 'obsidian [d]aily' },
    { '<leader>mt', ':ObsidianToday 1<cr>', desc = 'obsidian [t]omorrow' },
    { '<leader>my', ':ObsidianToday -1<cr>', desc = 'obsidian [y]esterday' },
    { '<leader>mb', ':ObsidianBacklinks<cr>', desc = 'obsidian [b]acklinks' },
    { '<leader>ml', ':ObsidianLink<cr>', desc = 'obsidian [l]ink selection' },
    { '<leader>mf', ':ObsidianFollowLink<cr>', desc = 'obsidian [f]ollow link' },
    { '<leader>mn', ':ObsidianNew<cr>', desc = 'obsidian [n]ew' },
    { '<leader>ms', ':ObsidianSearch<cr>', desc = 'obsidian [s]earch' },
    { '<leader>mo', ':ObsidianQuickSwitch<cr>', desc = 'obsidian [o]pen quickswitch' },
    { '<leader>mO', ':ObsidianOpen<cr>', desc = 'obsidian [O]pen in app' },
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('obsidian').setup {
      workspaces = {
        {
          name = 'Notes',
          path = '~/Notes',
        },
      },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- create and toggle checkboxes
        ['<cr>'] = {
          action = function()
            local line = vim.api.nvim_get_current_line()
            if line:match '%s*- %[' then
              require('obsidian').util.toggle_checkbox()
            elseif line:match '%s*-' then
              vim.cmd [[s/-/- [ ]/]]
              vim.cmd.nohlsearch()
            end
          end,
          opts = { buffer = true },
        },
      },
      -- Optional, customize how names/IDs for new notes are created.
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ''
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
      end,
    }

    vim.wo.conceallevel = 1
  end,
}
