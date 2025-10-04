local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
	s({ trig = "template", name = "Task Template" }, {
		t({
			"---",
			'status: "pending"',
			'priority: "medium"',
			'due_date: ""',
			"---",
			"",
			"# Title",
			"",
			"## Description",
			"",
			"A brief description of the task.",
			"",
			"## Sub-Tasks",
			"",
			"- [ ] Sub-task 1",
			"- [ ] Sub-task 2",
			"- [ ] Sub-task 3",
			"",
			"## Related Tasks",
			"",
			"- [[path/to/related-task.md]]",
		}),
	}),
}
