import { Denops, fn } from "./deps.ts";

export const deletebufline = fn.deletebufline as (denops: Denops, buf: number | string, first: number | string, last?: number | string) => Promise<void>;

export const getcwd = fn.getcwd as (denops: Denops, winnr?: number, tabnr?: number) => Promise<string>;
