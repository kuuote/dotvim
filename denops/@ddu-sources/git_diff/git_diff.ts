export const splitAtFile = (lines: string[]): string[][] => {
  // diff --gitを起点とした塊に分解
  return lines.flatMap((l, i) => l.startsWith("diff --git") ? [i] : [])
    .map((start, idx, arr) => lines.slice(start, arr[idx + 1] ?? -1))
    .flatMap((lines) => {
      const stripped = lines.slice(
        lines.findIndex((line) => line.startsWith("+++")),
      );
      if (stripped[0] == null || stripped[0] === "+++ /dev/null") {
        return [];
      }
      return [stripped];
    })
};

type DiffLine = {
  text: string;
  linum: number;
};

export type DiffData = {
  fileName: string;
  lines: DiffLine[];
};

export const parseHunk = (lines: string[]): DiffLine[] => {
  const parsed: DiffLine[] = [];
  const m = lines[0].match(/\+(\d+)/);
  if (m == null) {
    throw Error("m == null");
  }
  let linum = parseInt(m[0]);
  parsed.push({
    text: lines[0],
    linum,
  });
  for (let i = 1; i < lines.length; i++) {
    parsed.push({
      text: lines[i],
      linum: lines[i].startsWith("-") ? linum : linum++,
    });
  }
  return parsed;
};

export const parseDiff = (lines: string[]): DiffData => {
  const fileName = lines[0].slice(4).replace(/\t$/, "");
  const diffLines = lines.flatMap((l, i) => l.startsWith("@@") ? [i] : [])
    .map((start, idx, arr) => lines.slice(start, arr[idx + 1] ?? -1))
    .flatMap(parseHunk)
  return {
    fileName,
    lines: diffLines,
  }
}
