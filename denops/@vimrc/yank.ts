import { Denops } from "jsr:@denops/std";
import { encodeBase64 } from "jsr:@std/encoding/base64";

async function yankWayland(text: string) {
  const wlCopy = new Deno.Command("wl-copy", {
    args: ["--type", "text/plain"],
    stdin: "piped",
    stdout: "null",
    stderr: "null",
  }).spawn();
  const w = wlCopy.stdin.getWriter();
  w.write(new TextEncoder().encode(text))
    .finally(() => w.close());
  await wlCopy.status;
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
  let type = "";
  const isWayland = Deno.env.get("WAYLAND_DISPLAY") != "" &&
    Boolean(await denops.call("executable", "wl-copy"));
  if (isWayland) {
    type = "wayland";
  } else {
    type = "osc52";
  }
  await denops.cmd("autocmd vimrc User vimrc.yank :");
  denops.dispatcher = {
    async yank(text: unknown) {
      const trimText = union(text).trimEnd();
      if (type === "wayland") {
        await yankWayland(trimText);
      } else if (type === "osc52") {
        await oscyank(denops, trimText);
      } else {
        await denops.cmd("echomsg msg", { msg: "no yank provider: " + type });
        return;
      }
      await denops.cmd("echomsg msg", { msg: "yank text" });
      await denops.cmd("doautocmd <nomodeline> User vimrc.yank");
    },
  };
  // await denops.cmd(
  //   `nnoremap <CR> <Cmd>call denops#request('${denops.name}', 'yank', [getline(1, '$')->join("\\n")])<CR>`,
  // );
  // await denops.cmd(
  //   `xnoremap <CR> y<Cmd>call denops#request('${denops.name}', 'yank', [getreg(v:register)])<CR>`,
  // );
}
