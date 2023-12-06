import { is, u } from "../../../denops/deps/unknownutil.ts";

export async function exec(cmd: string[], cwd?: string): Promise<string> {
  if (cwd == null) {
    cwd = Deno.cwd();
  }
  const proc = new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    cwd,
  });
  const { stdout } = await proc.output();
  return new TextDecoder().decode(stdout).trimEnd();
}

export type Repo = {
  path: string;
  hash: string;
  date: number;
};

export const isRepo: u.Predicate<Repo> = is.ObjectOf({
  path: is.String,
  hash: is.String,
  date: is.Number,
});

export async function getSnapshot(path: string): Promise<Repo | null> {
  const out = await exec(
    [
      "git",
      "log",
      "-1",
      "--pretty=format:%H %ct",
    ],
    path,
  ).catch(String);
  const match = out.match(/([0-9a-f]+) ([0-9]+)/);
  if (match == null) {
    return null;
  }
  return {
    path,
    hash: match[1],
    date: Number(match[2]),
  };
}
