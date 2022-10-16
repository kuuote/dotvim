import { Param, Snippet } from "https://deno.land/x/tsnip_vim@v0.4/mod.ts";

const tsnip: Snippet = {
  name: "tsnip",
  text: "tsnip snippet of tsnip",
  params: [
    {
      name: "name",
      type: "single_line",
    },
    {
      name: "params",
      type: "multi_line",
    },
  ],
  render: (input) => {
    const name = input.name?.text ?? "";
    const paramsStr = input.params?.text ?? "";
    const params = String(paramsStr).split("\n")
      .filter((s) => s.length !== 0)
      .map((s: string): Param => ({
        // 末尾に`.`入れるとmulti_lineになります
        name: s.endsWith(".") ? s.slice(0, -1) : s,
        type: s.endsWith(".") ? "multi_line" : "single_line",
      }));
    const header = [
      `const ${name}: Snippet = {`,
      `\tname: "${name}",`,
      "\tparams: [",
    ];
    const paramsText = params.flatMap((p) => [
      "\t\t{",
      `\t\t\tname: "${p.name}",`,
      `\t\t\ttype: "${p.type}",`,
      "\t\t},",
    ]);
    const footer = [
      "\t],",
      `\trender: ({ ${params.map((p) => p.name).join(", ")} }) => {`,
      "\t\t{{_cursor_}}",
      "\t},",
      "}",
    ];
    return [
      header,
      paramsText,
      footer,
    ].flat().join("\n");
  },
};

export default {
  tsnip,
};
