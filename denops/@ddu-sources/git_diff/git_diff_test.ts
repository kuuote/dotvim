import { parseDiff, parseHunk, splitAtFile } from "./git_diff.ts";
import { assertEquals } from "/data/deno/std/testing/asserts.ts";
import * as path from "/data/deno/std/path/mod.ts";

const dir = path.dirname(path.fromFileUrl(import.meta.url));

Deno.test({
  name: "splitAtFile",
  fn() {
    const diff = Deno.readTextFileSync(
      path.join(dir, "test", "split_at_file.diff"),
    ).split("\n");
    const files = splitAtFile(diff);

    assertEquals(files, [
      [
        "+++ a.diff",
        "@@ -0,0 +1,14 @@",
        "+diff --git foo foo",
        "+deleted file mode 100644",
        "+index 257cc56..0000000",
        "+--- foo",
        "++++ /dev/null",
        "+@@ -1 +0,0 @@",
        "+-foo",
        "+diff --git hoge hoge",
        "+index 2262de0..0ef7e93 100644",
        "+--- hoge",
        "++++ hoge",
        "+@@ -1 +1 @@",
        "+-hoge",
        "++piyo",
      ],
      [
        "+++ b a r\t",
        "@@ -0,0 +1 @@",
        "+foo",
      ],
      [
        "+++ hoge",
        "@@ -1 +1 @@",
        "-hoge",
        "+piyo",
      ],
    ]);
  },
});

Deno.test({
  name: "parseHunk",
  fn() {
    const lines = Deno.readTextFileSync(
      path.join(dir, "test", "parse_hunk.diff"),
    ).split("\n");
    const diff = splitAtFile(lines)[0];
    assertEquals(parseHunk(diff.slice(1)), [
      { text: "@@ -1,6 +1,6 @@", linum: 1 },
      { text: " a", linum: 1 },
      { text: "-b", linum: 2 },
      { text: " c", linum: 2 },
      { text: "+b", linum: 3 },
      { text: " d", linum: 4 },
      { text: "-e", linum: 5 },
      { text: " f", linum: 5 },
      { text: "+e", linum: 6 },
    ]);
  },
});

Deno.test({
  name: "parseDiff",
  fn() {
    const lines = Deno.readTextFileSync(
      path.join(dir, "test", "parse_diff.diff"),
    ).split("\n");
    const diff = splitAtFile(lines)[0];
    const data = parseDiff(diff);
    assertEquals(data, {
      fileName: "test",
      lines: [
        { text: "@@ -1,5 +1,4 @@", linum: 1 },
        { text: " 0", linum: 1 },
        { text: "-1", linum: 2 },
        { text: " 2", linum: 2 },
        { text: " 3", linum: 3 },
        { text: " 4", linum: 4 },
        { text: "@@ -8,6 +7,7 @@", linum: 7 },
        { text: " 7", linum: 7 },
        { text: " 8", linum: 8 },
        { text: " 9", linum: 9 },
        { text: "+9", linum: 10 },
        { text: " 10", linum: 11 },
        { text: " 11", linum: 12 },
      ],
    });
  },
});
