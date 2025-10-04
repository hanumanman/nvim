-- Load custom snippets
local ls = require("luasnip")

-- Load JSON snippets for both json and jsonc files
local json_snippets = require("snippets.json")
ls.add_snippets("json", json_snippets)
ls.add_snippets("jsonc", json_snippets)

-- Load JavaScript snippets
local javascript_snippets = require("snippets.javascript")
local typescript_snippets = require("snippets.typescript")
ls.add_snippets("javascript", javascript_snippets)
ls.add_snippets("typescript", javascript_snippets)
ls.add_snippets("typescript", typescript_snippets)
ls.add_snippets("javascriptreact", javascript_snippets)
ls.add_snippets("typescriptreact", javascript_snippets)

-- Load Markdown snippets
local markdown_snippets = require("snippets.markdown")
ls.add_snippets("markdown", markdown_snippets)
