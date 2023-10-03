// rhysd/vim-startuptimeと同じことをしてくれるやつ

const withTempFile = async (fn: (file: string) => unknown) => {
  const file = await Deno.makeTempFile();
  try {
    await fn(file);
  } finally {
    await Deno.remove(file).catch(() => {});
  }
};

type Time = [inclusive: number, exclusive: number];

const parseLine = (
  line: string,
): [key: string, time: Time] => {
  const [time, key] = line.split(/: /);
  const times = time.split(/\s+/)
    .map((t) => parseFloat(t));
  return [key, [times[1], times[2] ?? 0]];
};

const timeToString = (time: number): string => time.toFixed(3).padStart(7, "0");

const collectResult = (
  totals: number[],
  times: Map<string, Time[]>,
  exclusive: boolean,
): string => {
  const a = [...times.entries()]
    .map(([key, times]): [string, number] => [
      key,
      times.map((t) => t[exclusive ? 1 : 0]).reduce((a, b) => a + b) /
      times.length,
    ])
    .sort((a, b) => a[1] - b[1])
    .map(([key, time]) => timeToString(time) + " " + key);
  a.push(
    `avg: ${
      timeToString(totals.reduce((a, b) => a + b) / totals.length)
    } max: ${timeToString(Math.max(...totals))} min: ${
      timeToString(Math.min(...totals))
    }`,
  );
  return a.join("\n");
};

withTempFile(async (file: string) => {
  const totals: number[] = [];
  const times = new Map<string, Time[]>();
  // warmup
  await new Deno.Command(Deno.args[0], { args: [file] }).output();
  for (let i = 0; i < 50; i++) {
    await Deno.stderr.write(new TextEncoder().encode("\r" + (i + 1)));
    await Deno.remove(file).catch(() => {});
    await new Deno.Command(Deno.args[0], { args: [file] }).output();
    const lines = (await Deno.readTextFile(file)).split(/\n/);
    const total = parseFloat(
      lines.find((line) => line.includes("VIM STARTED"))
        ?.replace(/\s.*/, "") ?? "",
    );
    totals.push(total);
    for (const line of lines) {
      if (line.match(/^\d/) == null) {
        continue;
      }
      const [key, time] = parseLine(line);
      times.set(key, [time].concat(times.get(key) ?? []));
    }
  }
  console.log("inclusive");
  console.log(collectResult(totals, times, false));
  console.log("exclusive");
  console.log(collectResult(totals, times, true));
});
