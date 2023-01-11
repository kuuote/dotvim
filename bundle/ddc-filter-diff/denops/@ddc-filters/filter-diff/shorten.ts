export function commonString(haystack: string, needle: string): string {
  const matches: string[] = [];
  let pos = 0;
  for (const c of needle) {
    const p = haystack.indexOf(c, pos);
    if (p !== -1) {
      matches.push(c);
      pos = p;
    }
  }
  return matches.join("");
}

export function findShortest(haystack: string, needle: string): number[] {
  let currentDistance = Number.POSITIVE_INFINITY;
  let currentMatches: number[] = [];
  const matches = Array.from(
    Array(needle.length),
    () => Number.NEGATIVE_INFINITY,
  );
  let pos = 0;
  let npos = 0;
  while (true) {
    const p = haystack.indexOf(needle[npos], pos);
    if (p == -1) {
      break;
    }
    matches[npos++] = p;
    pos = p + 1;
    // 前回のマッチ結果を再利用する
    // 現在のマッチより次のマッチが大きければ結果は変わらないので飛ばす
    if (npos == needle.length || pos < matches[npos]) {
      const distance = matches[needle.length - 1] - matches[0];
      if (distance < currentDistance) {
        currentDistance = distance;
        currentMatches = [...matches];
      }
      // マッチの先頭の直後からやり直し
      pos = matches[0] + 1;
      npos = 0;
    }
  }
  return currentMatches;
}
