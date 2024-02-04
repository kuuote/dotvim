import { Denops } from "../../@deps/denops_std.ts";

export type GenerateDenopsCallOptions = {
  async?: boolean;
  escapeLt?: boolean;
};

export function generateDenopsCall(
  denops: Denops,
  method: string,
  args: string | unknown[],
  options: GenerateDenopsCallOptions = {},
): string {
  if (Array.isArray(args)) {
    args = JSON.stringify(args);
  }
  if (options.escapeLt) {
    args = args.replaceAll(/</, "<lt>");
  }
  const callType = options.async ? "notify" : "request";
  return `denops#${callType}('${denops.name}', '${method}', ${args})`;
}
