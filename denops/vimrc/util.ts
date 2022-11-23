import { anonymous, Denops } from "./deps.ts";

export async function defineCommand(
  denops: Denops,
  name: string,
  fn: () => unknown,
) {
  const id = anonymous.add(denops, fn)[0];
  await denops.cmd(`command! ${name} call denops#request('${denops.name}', '${id}', [])`);
}