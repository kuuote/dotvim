import { is, u } from "../../denops/deps/unknownutil.ts";
import { isTask, Task } from "./run.ts";

export async function loadTasks(pathes: string[]): Promise<Task[]> {
  const tasks = [];
  for (const path of pathes) {
    try {
      const data = await Deno.readTextFile(path);
      const json = JSON.parse(data);
      u.assert(json, is.ArrayOf(isTask));
      tasks.push(...json);
    } catch (e) {
      console.log("skip " + path);
      console.trace(e);
    }
  }
  return tasks;
}
