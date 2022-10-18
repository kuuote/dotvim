import { Snippet } from "https://deno.land/x/tsnip_vim@v0.4/mod.ts";

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
  render: ({ name, args }) =>
    [
      `function! ${suggestFunctionName(name?.text)}(${args?.text ?? ""}) abort`,
      "\t{{_cursor_}}",
      "endfunction",
    ].join("\n"),
};

export default {
  "function_snip": fn,
};
