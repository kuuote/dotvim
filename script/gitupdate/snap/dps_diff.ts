import { Denops } from "../../../denops/deps/denops_std.ts";
import { is, u } from "../../../denops/deps/unknownutil.ts";
import { exec, isRepo } from "./libsnapshot.ts";

export async function run(denops: Denops, args: unknown) {
  u.assert(
    args,
    is.TupleOf(
      [
        is.String,
      ] as const,
    ),
  );
  const [snapshotPath] = args;

  const repos = u.ensure(
    JSON.parse(
      await Deno.readTextFile(snapshotPath),
    ),
    is.ArrayOf(isRepo),
  );

  await denops.cmd(
    [
      "tabnew",
      "setlocal buftype=nofile bufhidden=wipe noswapfile nowrap",
      "syntax match Number /^ [^|]\\+\\ze|/",
      "syntax match diffAdded /+/",
      "syntax match diffRemoved /-/",
    ].join("|"),
  );
  const bufnr = Number(await denops.call("bufnr"));
  await denops.call("setbufline", bufnr, "$", "plugins diff output v1");

  await Deno.remove("/tmp/vimdiff", {
    recursive: true,
  }).catch(console.trace);
  await Deno.mkdir("/tmp/vimdiff", {
    recursive: true,
  });

  for (const repo of repos) {
    const hash = await exec(["git", "rev-parse", "@"], repo.path);
    if (repo.hash === hash) {
      continue;
    }

    const diff = (await exec(
      ["git", "diff", "--stat", repo.hash, "HEAD"],
      repo.path,
    )).split(/\n/);

    await denops.call("appendbufline", bufnr, "$", repo.path);
    await denops.call("appendbufline", bufnr, "$", diff);

    await denops.redraw();

    const hashes = await exec(
      [
        "git",
        "log",
        "--since=" + (repo.date + 1),
        "--pretty=format:%H",
      ],
      repo.path,
    )
      .then((o) => o.split(/\n/));
    if (hashes[0] === "") {
      continue;
    }
    const dir = "/tmp/vimdiff/" + repo.path.replaceAll(/\//g, "_") + "/";
    Deno.mkdir(dir);
    const pad = String(hashes.length).length;
    for (let i = 0; i < hashes.length; i++) {
      const show = await exec(
        ["git", "show", hashes[i]],
        repo.path,
      );
      await Deno.writeTextFile(
        dir + String(i + 1).padStart(pad, "0") + ".diff",
        show,
      );
    }
  }
  await denops.cmd(
    [
      "tabnew",
      "setlocal buftype=nofile bufhidden=wipe noswapfile nowrap",
    ].join("|"),
  );
  await denops.call("setline", "1", "done");
  await denops.redraw();
}

export function main(denops: Denops) {
  denops.dispatcher = {
    run: (...args: unknown[]) => run(denops, args),
  };
}
