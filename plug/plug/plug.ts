import {exists} from 'https://deno.land/std@0.99.0/fs/exists.ts';

export type PluginOption = {
  branch: string;
  tag: string;
  commit: string;
  do: string;
  using: boolean;
};

const plugins: Record<string, PluginOption> = {};

function getPlugins(): [string, PluginOption][] {
  return Object.entries(plugins).sort((a, b) => a[0].localeCompare(b[0]));
}

export function registerPlugin(path: string, option: PluginOption): void {
  plugins[path] = option;
}

function normalizeRepositoryPath(path: string): string {
  if (path.startsWith("http")) {
    return path;
  } else {
    return "https://github.com/" + path;
  }
}

function getLocalPath(root: string, path: string): string {
  return root + "/" + normalizeRepositoryPath(path).replace(/.*\/\//, "");
}

async function updatePlugin(
  repositoryRoot: string,
  path: string,
  option: PluginOption,
  forceUpdate: boolean,
) {
  const dir = getLocalPath(repositoryRoot, path);
  if (forceUpdate) {
    const tmp = repositoryRoot + "/.plug.tmp";
    await Deno.mkdir(dir, { recursive: true });
    await Deno.run({
      cmd: ["git", "init", dir],
    }).status();
    await Deno.remove(tmp, { recursive: true }).catch(() => {});
    const cmd = [["git", "clone"], option.branch ? ["-b", option.branch] : [], [
      "--reference",
      dir,
      "--dissociate",
      path,
      tmp,
    ]].flat();
    await Deno.run({
      cmd,
    }).status();
    await Deno.remove(dir, { recursive: true });
    await Deno.rename(tmp, dir);
  } else if(await exists(dir)) {
    // update
    const cwd = Deno.cwd();
    try {
      Deno.chdir(dir);
      await Deno.run({
        cmd: ["git", "pull"],
      }).status();
    } finally {
      Deno.chdir(cwd);
    }
  } else {
    await Deno.run({
      cmd: ["git", "clone", path, dir],
    }).status();
  }
}

export async function updatePlugins(
  repositoryRoot: string,
  forceUpdate = false,
): Promise<void> {
  for (const e of getPlugins()) {
    const path = normalizeRepositoryPath(e[0]);
    await updatePlugin(repositoryRoot, path, e[1], forceUpdate);
  }
}

export async function assemblePlugins(
  repositoryRoot: string,
  vimrcPath: string,
) {
  const rtp = getPlugins().filter((e) => e[1].using).map((e) =>
    getLocalPath(repositoryRoot, e[0])
  ).sort().join(",");
  const vimrc = [
    `set runtimepath^=${rtp}`,
  ];
  console.log("write");
  await Deno.writeTextFile(
    vimrcPath,
    vimrc.join("\n"),
  );
}
