import { Snippet } from "https://deno.land/x/tsnip_vim@v0.5/mod.ts";

const deinHook: Snippet = {
  name: "deinHook",
  params: [
    {
      name: "name",
      type: "single_line",
    },
  ],
  render: ({ name }, ctx) => {
    let text = name?.text ?? "";
    if (text[0] === "h") {
      text = "hook_" + text.slice(1);
    }
    if (text[0] === "l") {
      text = "lua_" + text.slice(1);
    }
    return `${text} = '''\n${ctx.postCursor}\n'''`;
  },
};

export default {
  "dein_hook": deinHook,
};
