local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('schema', {
    t('"$schema": "'),
    i(1),
    t('"'),
  }),
  s('biome', {
    t({
      '{',
      '  "$schema": "https://biomejs.dev/schemas/2.5.10/schema.json",',
      '  "assist": {',
      '    "actions": {',
      '      "source": { "organizeImports": "on" },',
      '    },',
      '  },',
      '  "formatter": {',
      '    "indentStyle": "space",',
      '    "indentWidth": 2,',
      '    "lineWidth": 80,',
      '  },',
      '  "javascript": {',
      '    "formatter": {',
      '      "quoteStyle": "double",',
      '      "semicolons": "asNeeded",',
      '      "trailingCommas": "none",',
      '      "arrowParentheses": "asNeeded",',
      '    },',
      '  },',
      '}',
    }),
  }),
  s('prettier', {
    t({
      '{',
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
      '  ],',
      '  "importOrder": [',
      '    "^@core/(.*)$",',
      '    "<THIRD_PARTY_MODULES>",',
      '    "^@server/(.*)$",',
      '    "^@ui/(.*)$",',
      '    "^[./]"',
      '  ]',
      '}',
    }),
  }),
}
