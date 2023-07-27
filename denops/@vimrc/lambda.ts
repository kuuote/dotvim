import * as mapping from "../../deno/denops_std/denops_std/mapping/mod.ts";
import * as lambda from "../../deno/denops_std/denops_std/lambda/mod.ts";
import * as fn from "../../deno/denops_std/denops_std/function/mod.ts";
import { Denops } from "../../deno/denops_std/denops_std/mod.ts";
import * as u from "../../deno/unknownutil/mod.ts";

const mapFunc = "vimrc.lambda.map";
const mapTable: Record<string, lambda.Fn> = {};

// bufferはbatchで使えないはずなので注意
export async function map(
  denops: Denops,
  lhs: string,
  rhs: lambda.Fn,
  options: mapping.MapOptions = {},
): Promise<void> {
  denops.dispatcher[mapFunc] = (functionName: unknown) =>
    mapTable[String(functionName)]?.() ?? Promise.resolve();
  const mode = options.mode;
  const modeStr = u.maybe(mode, u.isArray)?.join("") ??
    u.maybe(mode, u.isString) ??
    "";
  const bufNr = options.buffer ? await fn.bufnr(denops) : -1;
  const lhsEscaped = lhs.replaceAll(/</g, "[less]");
  const functionName = `${modeStr}:${bufNr}:${lhsEscaped}`;
  mapTable[functionName] = rhs;
  const rhsStr =
    `<Cmd>call denops#request('${denops.name}', '${mapFunc}', ['${functionName}'])<CR>`;
  await mapping.map(denops, lhs, rhsStr, options);
}
