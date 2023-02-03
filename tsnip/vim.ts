import { Snippet } from "../bundle/tsnip/denops/tsnip/mod.ts";

const suggestFunctionName = (name?: string) => {
  if (name == null) {
    return "";
  }
  if (name.match(/^[A-Z]/)) {
    // global function
    return name;
  }
  if (name.includes("#")) {
    // autoload function
    return name;
  }
  // normal function turn to script local function
  // sometimes missing "s:"
  return "s:" + name;
};

const fn: Snippet = {
  name: "function",
  text: "function! ${1:name}(${2:args}) abort\n\t$0\nendfunction",
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
  render: ({ name, args }, ctx) =>
    [
      `function! ${suggestFunctionName(name?.text)}(${args?.text ?? ""}) abort`,
      `\t${ctx.postCursor}`,
      "endfunction",
    ].join("\n"),
};

const try_snip: Snippet = {
  name: "try_snip",
  params: [
    {
      name: "flags",
      type: "single_line",
    },
  ],
  render: ({ flags }, ctx) => {
    const base = `try\n\t${ctx.postCursor}\n`;
    const caught = flags?.text?.includes("c") ? "catch\n" : "";
    const final = flags?.text?.includes("f") ? "finally\n" : "";
    return base + caught + final + "endtry";
  },
};

export default {
  "function_snip": fn,
  try_snip,
};
