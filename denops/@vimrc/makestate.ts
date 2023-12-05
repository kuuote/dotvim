import {
  ensure,
  is,
} from "/data/vim/repos/github.com/lambdalisue/deno-unknownutil/mod.ts";
import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";
import { g } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/variable/mod.ts";

let vimProc: Deno.ChildProcess | undefined;
let nvimProc: Deno.ChildProcess | undefined;

const vimrc = Deno.env.get("VIMDIR") + "/vimrc";

const isStringArray = is.ArrayOf(is.String);
async function glob(denops: Denops, path: string): Promise<string[]> {
  return ensure(
    await denops.call("glob", path, 1, 1),
    isStringArray,
  );
}

export async function main(denops: Denops) {
  denops.dispatcher = {
    async run() {
      vimProc?.kill("SIGKILL");
      nvimProc?.kill("SIGKILL");
      const base = String(await g.get(denops, "vimrc#dpp_base", "/tmp/dpp"));
      const files = [
        ...await glob(denops, base + "/*/cache.vim"),
        ...await glob(denops, base + "/*/state.vim"),
      ];
      for (const f of files) {
        await Deno.remove(f);
      }
      // await Deno.remove(base, { recursive: true }).catch(console.trace);
      // 並列で実行すると多分denoのlockに引っ掛かる
      vimProc = new Deno.Command("vim", {
        args: ["-e", "-s", "-u", vimrc],
        env: {
          VIM: "",
          VIMRUNTIME: "",
        },
        stdin: "piped",
        stdout: "piped",
        stderr: "piped",
      }).spawn();
      const vimStatus = await vimProc.status;
      vimProc = void 0;
      if (vimStatus.success) {
        console.log("vim success");
      }
      nvimProc = new Deno.Command("nvim", {
        args: ["--headless", "-u", vimrc],
        env: {
          VIM: "",
          VIMRUNTIME: "",
        },
        stdin: "piped",
        stdout: "piped",
        stderr: "piped",
      }).spawn();
      const nvimStatus = await nvimProc.status;
      nvimProc = void 0;
      if (nvimStatus.success) {
        console.log("nvim success");
      }
    },
    status() {
      const stat = [];
      if (vimProc != null) {
        stat.push("vim");
      }
      if (nvimProc != null) {
        stat.push("nvim");
      }
      return stat;
    },
  };
}
