import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";
import { find } from "../ahocorasick.ts";
import * as lambda from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/lambda/mod.ts";
import * as autocmd from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/autocmd/mod.ts";
import {
  generateDenopsCall,
  GenerateDenopsCallOptions,
} from "/data/newvim/new/denops/@vimrc/lib/denops.ts";

const dispatchName = "lambda.autocmd#" + performance.now();
const dispatcher = new Map<string, lambda.Fn>();

export async function garbagecollect(denops: Denops) {
  const autocmds = String(await denops.call("execute", "autocmd"));
  const names = [...dispatcher.keys()];
  const found = find(autocmds, names);
  for (const name of dispatcher.keys()) {
    if (!found.has(name)) {
      dispatcher.delete(name);
    }
  }
}

type RegisterOptions = GenerateDenopsCallOptions & {
  args?: string;
};

export function register(
  denops: Denops,
  fn: lambda.Fn,
  options: RegisterOptions = {},
): string {
  denops.dispatcher[dispatchName] = (name: unknown, ...args: unknown[]) =>
    dispatcher.get(String(name))?.(...args);
  const id = crypto.randomUUID();
  dispatcher.set(id, fn);
  return "call " + generateDenopsCall(
    denops,
    dispatchName,
    `['${id}', ${options.args ?? ""}]`,
    options,
  );
}

type LambdaGroupDefineOptions =
  & autocmd.GroupDefineOptions
  & GenerateDenopsCallOptions
  & {
    args?: string;
    description?: string;
  };

class LambdaGroupHelper {
  #denops;
  #helper;
  constructor(denops: Denops, helper: autocmd.GroupHelper) {
    this.#denops = denops;
    this.#helper = helper;
  }

  /**
   * Define an autocmd
   */
  define(
    event: autocmd.AutocmdEvent | autocmd.AutocmdEvent[],
    pat: string | string[],
    cmd: string | lambda.Fn,
    options: LambdaGroupDefineOptions = {},
  ): void {
    if (typeof cmd != "string") {
      cmd = register(this.#denops, cmd, options);
    }
    this.#helper.define(event, pat, cmd, options);
  }

  /**
   * Remove an autocmd
   */
  remove(
    event?: "*" | autocmd.AutocmdEvent | autocmd.AutocmdEvent[],
    pat?: string | string[],
    options: autocmd.GroupRemoveOptions = {},
  ): void {
    this.#helper.remove(event, pat, options);
  }
}

export type { LambdaGroupHelper };

export async function group(
  denops: Denops,
  name: string,
  executor: (helper: LambdaGroupHelper) => void,
): Promise<void> {
  await autocmd.group(
    denops,
    name,
    (helper) => executor(new LambdaGroupHelper(denops, helper)),
  );
  await garbagecollect(denops);
}
