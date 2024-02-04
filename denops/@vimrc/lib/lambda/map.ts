import { Denops, fn, lambda, mapping } from "../../../@deps/denops_std.ts";
import { is, u } from "../../../@deps/unknownutil.ts";

const { bufnr } = fn;

const dispatchName = "lambda.map" + performance.now();
const dispatcher = new Map<string, lambda.Fn>();

export async function map(
  denops: Denops,
  lhs: string,
  rhs: lambda.Fn,
  options: mapping.MapOptions = {},
): Promise<void> {
  denops.dispatcher[dispatchName] = (functionName: unknown) =>
    dispatcher.get(String(functionName))?.() ?? Promise.resolve();
  const mode = options.mode;
  const modeStr = u.maybe(mode, is.Array)?.join("") ??
    u.maybe(mode, is.String) ??
    "";
  const bufNr = options.buffer ? await bufnr(denops) : -1;
  const lhsEscaped = lhs.replaceAll(/</g, "[less]");
  const functionName = `${modeStr}:${bufNr}:${lhsEscaped}`;
  dispatcher.set(functionName, rhs);
  const rhsStr =
    `<Cmd>call denops#request('${denops.name}', '${dispatchName}', ['${functionName}'])<CR>`;
  await mapping.map(denops, lhs, rhsStr, options);
}

export type CommandOptions = {
  async?: boolean;
  buffer?: boolean;
};

export type CommandArg = {
  bang: boolean;
  arg: string;
};

export type CommandFn = (arg: CommandArg) => void | Promise<void>;

const cmdFunc = "vimrc.lambda.cmd" + Math.random();
const cmdTable: Record<string, CommandFn> = {};

export async function cmd(
  denops: Denops,
  name: string,
  fn: CommandFn,
  opt: CommandOptions = {},
) {
  denops.dispatcher[cmdFunc] = (
    functionName: unknown,
    bang: unknown,
    arg: unknown,
  ) =>
    cmdTable[String(functionName)]?.({
      bang: Boolean(bang),
      arg: String(arg),
    }) ?? Promise.resolve();
  const bufNr = opt.buffer ? Number(await denops.call("bufnr")) : -1;
  const functionName = `${bufNr}:${name}`;
  cmdTable[functionName] = fn;
  await denops.cmd(
    `command! ${opt.buffer ? "-buffer" : ""} -nargs=* ${name} call denops#${
      opt.async ? "notify" : "request"
    }('${denops.name}', '${cmdFunc}', ['${functionName}', <bang>0, <q-args>])`,
  );
}
