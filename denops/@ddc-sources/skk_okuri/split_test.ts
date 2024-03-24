import { assertEquals } from "/data/vim/repos/github.com/denoland/deno_std/assert/assert_equals.ts";
import { split } from "./split.ts";

Deno.test({
  name: "split",
  fn() {
    const expect = [
      ["ばりか", "た"],
      ["ばり", "かた"],
      ["ば", "りかた"],
    ];
    assertEquals(split("ばりかた"), expect);
    assertEquals(split("あ"), []);
    assertEquals(split(""), []);
  },
});
