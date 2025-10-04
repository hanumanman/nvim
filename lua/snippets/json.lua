local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
	s("prettier", {
		t({
			"{",
			'  "$schema": "https://json.schemastore.org/prettierrc",',
			'  "semi": false,',
			'  "singleQuote": false,',
			'  "tabWidth": 2,',
			'  "trailingComma": "none",',
			'  "printWidth": 80,',
			'  "bracketSpacing": true,',
			'  "arrowParens": "avoid",',
			'  "endOfLine": "lf",',
			'  "plugins": [',
			'    "@trivago/prettier-plugin-sort-imports",',
			'    "prettier-plugin-tailwindcss"',
			"  ],",
			'  "importOrder": [',
			'    "^@core/(.*)$",',
			'    "<THIRD_PARTY_MODULES>",',
			'    "^@server/(.*)$",',
			'    "^@ui/(.*)$",',
			'    "^[./]"',
			"  ]",
			"}",
		}),
	}),
}
