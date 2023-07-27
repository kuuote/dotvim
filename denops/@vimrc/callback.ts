import { Denops } from "../../deno/denops_std/denops_std/mod.ts";
import * as lambda from "../../deno/denops_std/denops_std/lambda/mod.ts";

export async function registerCallback(
  denops: Denops,
  fn: lambda.Fn,
  type: "request" | "notify" = "request",
): Promise<string> {
  const id = lambda.register(denops, fn);
  return await denops.eval(
    `denops#callback#register({...->denops#${type}('${denops.name}', '${id}', a:000)})`,
  ) as string;
}
