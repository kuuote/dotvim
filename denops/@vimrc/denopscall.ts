import { Denops } from "../../deno/denops_std/denops_std/mod.ts";

export function generateDenopsRequest(
  denops: Denops,
  method: string,
  args: string | unknown[],
): string {
  if (Array.isArray(args)) {
    args = JSON.stringify(args);
  }
  return `denops#request('${denops.name}', '${method}', ${args})`;
}
