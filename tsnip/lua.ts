import { Snippet } from "https://deno.land/x/tsnip_vim@v0.4/mod.ts";

const func: Snippet = {
  name: "func",
  text: "function ${1:name}(${2:args})\n\t$0\nend",
  params: [
    {
      name: "name",
      type: "single_line",
    },
    {
      name: "args",
      type: "single_line",
    },
  ],
  render: ({ name, args }) => {
    return [
      `function${name?.text ? " " + name.text : ""}(${args?.text ?? ""})`,
      "\t{{_cursor_}}",
      "end",
    ].join("\n");
  },
};

const require: Snippet = {
  name: "require",
  params: [
    {
      name: "variable",
      type: "single_line",
    },
    {
      name: "module",
      type: "single_line",
    },
  ],
  render: ({ variable, module }) =>
    `local ${variable?.text ?? ""} = require('${module?.text ?? ""}')`,
};

export default {
  "function": func,
  require,
};
