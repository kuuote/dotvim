import { anonymous, Denops } from "./deps.ts";

export async function defineCommand(
  denops: Denops,
  name: string,
  fn: () => unknown,
) {
  const id = anonymous.add(denops, fn)[0];
  await denops.cmd(
    `command! ${name} call denops#request('${denops.name}', '${id}', [])`,
  );
}

export function notify(denops: Denops, msg: string) {
  return denops.call("luaeval", "vim.notify(_A.msg)", {
    msg,
  }).catch(() => console.log(msg));
}
}
