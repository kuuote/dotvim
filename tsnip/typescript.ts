import { Snippet, Param } from "https://deno.land/x/tsnip_vim@v0.5/mod.ts";

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
  render: (input, ctx) => {
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
      `\t\t${ctx.postCursor}}`,
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

const arrowFunction: Snippet = {
  name: "arrowFunction",
  text:
    "Arrow Function expander\ne.g. 'a; Promise<string>; text.string' to async (text: string): Promise<string> => |",
  params: [
    {
      name: "parameters",
      type: "single_line",
    },
  ],
  render: ({ parameters }, ctx) => {
    const [flag, _returnType, ...splits] = String(parameters?.text).split(";");
    const asyncText = flag.includes("a") ? "async " : "";
    let returnType = (_returnType ?? "").trim();
    returnType = returnType === "" ? "" : ": " + returnType;
    const params = splits.map((p) => p.trim().replace(/\./, ": ")).join(", ");
    return `${asyncText}(${params})${returnType} => ${ctx.postCursor}`;
  },
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
    const base = `try {\n\t${ctx.postCursor}\n}`;
    const caught = flags?.text?.includes("c") ? " catch (e: unknown) {\n}" : "";
    const final = flags?.text?.includes("f") ? " finally {\n}" : "";
    return base + caught + final;
  },
};

export default {
  arrowFunction,
  try_snip,
  tsnip,
};
