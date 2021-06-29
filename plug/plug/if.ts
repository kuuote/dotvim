import type { PluginOption } from "./plug.ts";
import { assemblePlugins, registerPlugin, updatePlugins } from "./plug.ts";

let using = true;
let profiles: string[] = [];

export function use(path: string, option: Partial<PluginOption> = {}) {
  console.log(path, option, using);
  const newOption = {
    ...{
      branch: "",
      tag: "",
      commit: "",
      do: "",
    },
    ...option,
    ...{ using },
  };
  registerPlugin(path, newOption);
}

export function usePredicate(use: boolean, fn: () => void) {
  const saveUsing = using;
  using &&= use;
  fn();
  using = saveUsing;
}

export function useProfile(profile: string, fn: () => void, invert = false) {
  if (invert) {
    usePredicate(!profiles.includes(profile), fn);
  } else {
    usePredicate(profiles.includes(profile), fn);
  }
}

type Option = {
  repositoryRoot: string;
  vimrc: string;
  forceUpdate: boolean;
};

export async function run(command: string, option: Option) {
  switch (command) {
    case "update":
      await updatePlugins(option.repositoryRoot, option.forceUpdate);
      break;
    case "assemble":
      await assemblePlugins(option.repositoryRoot, option.vimrc);
      break;
    default:
      console.error(`unknown command: ${command}`);
  }
}

export function setProfile(p: string[]) {
  profiles = profiles.concat(p);
}
