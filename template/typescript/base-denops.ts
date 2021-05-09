import { start } from "https://deno.land/x/denops_std@v0.7/mod.ts";

start(async (vim) => {
  vim.register({
    async echo(text: unknown): Promise<unknown> {
      console.log("echo is called");
      console.error("echo is not really implemented yet");
      return await Promise.resolve(text);
    },

    async register_autocmd(): Promise<void> {
      await vim.cmd("new");
      // Use 'vim.autocmd' to register autocmd
      await vim.autocmd("denops_helloworld", (helper) => {
        // Use 'helper.remove()' to remove autocmd
        helper.remove("*", "<buffer>");
        // Use 'helper.define()' to define autocmd
        helper.define(
          "CursorHold",
          "<buffer>",
          "echomsg 'Hello Denops CursorHold'",
        );
        helper.define(
          ["BufEnter", "BufLeave"],
          "<buffer>",
          "echomsg 'Hello Denops BufEnter/BufLeave'",
        );
      });
    },
  });

  // Use 'vim.execute()' to execute Vim script
  await vim.execute(`
    command! DenopsEcho echo denops#request("${vim.name}", "echo", ["This is hello world message"])
    command! DenopsRegisterAutocmd echo denops#notify("${vim.name}", "register_autocmd", [])
  `);

  console.log("denops-helloworld.vim (std) has loaded");
});
