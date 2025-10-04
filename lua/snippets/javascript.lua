local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
	s({ trig = "doc", name = "JSDoc comment" }, {
		t("/**"),
		t({ "", " * " }),
		i(1, "description"),
		t({ "", " * @param " }),
		i(2, "name"),
		t(" - "),
		i(3, "description"),
		t({ "", " * @returns " }),
		i(4, "type"),
		t(" - "),
		i(5, "description"),
		t({ "", " */" }),
	}),
	s({ trig = "afn", name = "Arrow function" }, {
		t("("),
		i(1),
		t(") => {"),
		i(2),
		t("}"),
	}),
}
