type Trie = {
  next: Record<string, Trie>;
  value?: string;
};

function makeTrie(needle: string[]): Trie {
  const root: Trie = {
    next: {},
  };
  for (const n of needle) {
    let current = root;
    for (let i = 0; i < n.length; i++) {
      const c = n[i];
      current = current.next[c] = current.next[c] ?? {
        next: {},
      };
      if (i == n.length - 1) {
        current.value = n;
      }
    }
  }
  return root;
}

export function find(haystack: string, needle: string[]): Set<string> {
  const found = new Set<string>();
  const root = makeTrie(needle);
  let current = root;
  for (let i = 0; i <= haystack.length; i++) {
    const c = haystack[i];
    if (current.next[c] == null) {
      if (current.value != null) {
        found.add(current.value);
      }
      current = root;
    }
    if (current.next[c] != null) {
      current = current.next[c];
    }
  }
  return found;
}

Deno.test({
  name: "find",
  fn() {
    const result = [...find("foobarbaz", ["foo", "ba", "buz", "baz", "qux"])];
    const actual = JSON.stringify(result);
    const expected = JSON.stringify(["foo", "ba", "baz"]);
    if (actual !== expected) {
      throw Error(`actual(${actual}) !== expected(${expected})`);
    }
  },
});
