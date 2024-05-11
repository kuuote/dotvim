import { Denops } from "../@deps/denops_std.ts";
import { encodeBase64 } from "/data/vim/deps/deno_std/encoding/base64.ts";

async function yankDetachWayland(text: string) {
  const wlCopy = new Deno.Command("wl-copy", {
    stdin: "piped",
    stdout: "null",
    stderr: "null",
  }).spawn();
  const w = wlCopy.stdin.getWriter();
  w.write(new TextEncoder().encode(text))
    .finally(() => w.close());
  await wlCopy.status;
  // detach tmux for VIME use
  await new Deno.Command("tmux", {
    args: ["detach-client"],
  }).output();
}

async function oscyank(denops: Denops, text: string) {
  const content = `\x1b]52;c;${encodeBase64(text)}\x1b\\`;
  if (denops.meta.host == "vim") {
    await denops.call("echoraw", content);
  } else {
    await denops.call("luaeval", "vim.api.nvim_chan_send(2, _A)", content);
  }
}

function union(text: unknown) {
  if (Array.isArray(text)) {
    return text.join("\n");
  }
  return String(text);
}

// X<denops-vimrc-yank>
export async function main(denops: Denops) {
  const isWayland = Deno.env.get("WAYLAND_DISPLAY") != "" &&
    Boolean(await denops.call("executable", "wl-copy"));
  denops.dispatcher = {
    async yank(text: unknown) {
      const trimText = union(text).trimEnd();
      if (isWayland) {
        await yankDetachWayland(trimText);
      } else {
        await oscyank(denops, trimText);
      }
      await denops.cmd("echomsg msg", { msg: "yank text" });
    },
  };
  // await denops.cmd(
  //   `nnoremap <CR> <Cmd>call denops#request('${denops.name}', 'yank', [getline(1, '$')->join("\\n")])<CR>`,
  // );
  // await denops.cmd(
  //   `xnoremap <CR> y<Cmd>call denops#request('${denops.name}', 'yank', [getreg(v:register)])<CR>`,
  // );
}
