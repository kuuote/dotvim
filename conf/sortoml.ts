async function sort(path: string) {
  console.log(`process ${path}`);
  const a = (await Deno.readTextFile(path)).split("\n");

  const qa: string[][] = [];
  let q: string[] = [];

  let inHereString = false;

  for (const s of a) {
    if (s.includes("'''")) {
      inHereString = !inHereString;
    }
    if (s === "" && !inHereString) {
      if (q.length !== 0) {
        qa.push(q);
        q = [];
      }
    } else {
      q.push(s);
    }
  }
  if (q.length !== 0) {
    qa.push(q);
  }

  const b = qa.map((sa) => sa.join("\n")).sort().join("\n\n") + "\n";
  await Deno.writeTextFile(path, b);
}

for (const path of Deno.args) {
  await sort(path);
}
