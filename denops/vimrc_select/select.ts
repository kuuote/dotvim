function filterLine(haystack: string, needle: string[]): boolean {
  const h = haystack.toLowerCase();
  for(const n of needle) {
    if(!h.includes(n)) {
      return false;
    }
  }
  return true;
}

export function select(haystack: string[], needle: string): string[] {
  const n = needle.split(" ").map((s) => s.toLowerCase());
  return haystack.filter((s) => filterLine(s, n));
}
