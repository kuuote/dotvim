import { Denops, lambda } from "../../denops/deps/denops_std.ts";
import { encodeBase64 } from "/data/vim/repos/github.com/denoland/deno_std/encoding/base64.ts";
import { ensure, is, PredicateType } from "../../denops/deps/unknownutil.ts";
import { generateDenopsCall } from "../../denops/@vimrc/lib/denops.ts";
import { stdpath, TOML } from "../../denops/deps/deno_std.ts";

// ビルドログ眺めてニヤニヤするやつ Version.2

const vimdir = String(Deno.env.get("VIMDIR"));

const isDefinitions = is.RecordOf(is.ObjectOf({
  script: is.String,
  deps: is.OptionalOf(is.ArrayOf(is.String)),
}));

type Definitions = PredicateType<typeof isDefinitions>;

async function load(
  path: string,
): Promise<Definitions> {
  return ensure(
    TOML.parse(await Deno.readTextFile(path)),
    isDefinitions,
  );
}

const isPlugin = is.ObjectOf({
  name: is.String,
  path: is.String,
});

type Plugin = PredicateType<typeof isPlugin>;
type Plugins = Record<string, Plugin>;

const isStringArray = is.ArrayOf(is.String);

async function glob(denops: Denops, path: string): Promise<string[]> {
  return ensure(
    await denops.call("glob", path, 1, 1),
    isStringArray,
  );
}

async function calculateHash(
  commit: string,
  pathes: string[],
): Promise<string> {
  const data = (await Promise.all(
    pathes
      .map((path) => Deno.readFile(path).catch((e) => e.toString())),
  ))
    .map((data) => encodeBase64(data));
  data.push(commit);
  const hash = await crypto.subtle.digest(
    "sha-256",
    new TextEncoder().encode(data.join()),
  );
  return encodeBase64(hash);
}

async function executermNvim(
  denops: Denops,
  definitions: Definitions,
  plugins: Plugins,
) {
  for (const [name, def] of Object.entries(definitions)) {
    const plugin = plugins[name];
    if (plugin == null) {
      console.log("undefined plugin " + name);
      continue;
    }
    const hashFile = stdpath.join(plugin.path, ".vimrc_hash");
    const oldHash = await Deno.readTextFile(hashFile).catch(() => "");

    const commit = await new Deno.Command("git", {
      args: ["rev-parse", "@{u}"],
      cwd: plugin.path,
    }).output()
      .then((o) => encodeBase64(o.stdout));

    const deps = (await Promise.all(
      (def.deps ?? [])
        .concat([def.script])
        .map((path) => glob(denops, path)),
    )).flat();

    const newHash = await calculateHash(commit, deps);
    if (oldHash === newHash) {
      continue;
    }

    await denops.cmd("autocmd TermOpen * normal! G");
    const code = ensure(
      await new Promise((resolve) => {
        const id = lambda.register(denops, resolve, { once: true });
        const notify = generateDenopsCall(denops, id, "[code]", {
          async: true,
        });
        const cmd =
          `$VIMDIR/script/build/build.sh ${plugin.path} ${def.script}`;
        denops.cmd("tabnew").then(() =>
          denops.eval(`termopen('${cmd}', #{on_exit: { _, code -> ${notify}}})`)
        );
      }),
      is.Number,
    );

    if (code === 0) {
      await Deno.writeTextFile(hashFile, newHash);
    }
  }
  // 全て終わった暁には…
  await denops.call("vimrc#dpp#makestate_job");
}

export async function main(denops: Denops) {
  const plugins = ensure(
    await denops.eval("g:dpp#_plugins"),
    is.RecordOf(isPlugin),
  );
  const defPath = stdpath.join(
    vimdir,
    "script",
    "build",
    "build.toml",
  );
  const localPath = stdpath.join(
    vimdir,
    "local",
    "build",
    "build.toml",
  );
  const definitions = await load(defPath);
  const local = await load(localPath).catch((e) => {
    // console.trace(e);
    return {};
  });
  for (const [name, def] of Object.entries(local)) {
    definitions[name] = def;
  }
  executermNvim(denops, definitions, plugins);
}
