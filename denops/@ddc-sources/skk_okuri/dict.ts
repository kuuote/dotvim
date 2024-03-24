export async function parse(path: string): Promise<Map<string, string[]>> {
  const dictionary = new Map<string, string[]>();
  const data = await Deno.readFile(path);
  const text = new TextDecoder("euc-jp").decode(data);
  const entries = text.split(";; okuri-nasi entries.")[0]
    .split(/\n/)
    .map((s) => {
      const m = s.match(/^([^; ]+) \/(.+)\/$/);
      if (m == null) {
        return;
      }
      return [m[1], m[2].split("/")] as const;
    })
    .filter(<T>(x: T): x is NonNullable<T> => x != null);
  for (const [midasi, candidates] of entries) {
    dictionary.set(midasi, (dictionary.get(midasi) ?? []).concat(candidates));
  }
  return dictionary;
}
