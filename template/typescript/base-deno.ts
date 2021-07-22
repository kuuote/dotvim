import { parse as parseArgs } from "https://deno.land/std@0.101.0/flags/mod.ts";

async function main(args: string[]): Promise<number> {
  const parsed = parseArgs(args, {
  });
  return 0;
}

Deno.exit(await main(Deno.args));
