import { Denops, fn } from "./deps.ts";

export const deletebufline = fn.deletebufline as (denops: Denops, buf: number | string, first: number | string, last?: number | string) => Promise<void>;
