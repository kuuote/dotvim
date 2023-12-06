import { Repo, exec } from "./libsnapshot.ts";

await Deno.remove("/tmp/vimdiff", {
  recursive: true,
}).catch(console.trace);
await Deno.mkdir("/tmp/vimdiff", {
  recursive: true,
});

const repos = JSON.parse(Deno.readTextFileSync(Deno.args[0])) as Repo[];
for (const repo of repos) {
  const hash = await exec(["git", "rev-parse", "@"], repo.path);
  if (repo.hash === hash) {
    continue;
  }
  console.log(repo.path);
  await new Deno.Command("git", {
    args: ["--no-pager", "diff", "--stat", repo.hash],
    cwd: repo.path,
  }).spawn().status;
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
