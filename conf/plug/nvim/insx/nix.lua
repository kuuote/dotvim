local insx = require("insx")
-- insx.add("<Space>", {
-- 	enabled = function(ctx)
--     return ctx.filetype == "nix" and ctx.match([[=\%#$]])
--   end,
--   action = function(ctx)
--     ctx.send('<Space>;<Left>')
--   end
-- })
insx.add(
	"<Space>",
	insx.with(
		require("insx.recipe.substitute")({
			pattern = [[ =\%#]],
			replace = [[ = \%#;]],
		}),
		{
			insx.with.filetype("nix"),
		}
	)
)
