/*
 * An O(NP) Sequence Comparison Algorithm implementation
 * by Sun Wu, Udi Manber, and Gene Myers
 * This is port of gonp
 * Copyright (c) 2014 Tatsuhiko Kubo <cubicdaiya@gmail.com>
 * https://github.com/cubicdaiya/gonp/blob/8ff9f3d28a8ec81060c44f3c8eaa527c96137cff/LICENSE
 * refs is here
 * https://www.semanticscholar.org/paper/An-O(NP)-Sequence-Comparison-Algorithm-Wu-Manber/c165c6f52f20f20e7f0e3d509b7bf78861c484f4
 * https://qiita.com/convto/items/e05d8147d9808a27b8ff
 * https://qiita.com/cubicdaiya/items/2ce3dce3b771de5c3733
 */

type Path = {
  x: number;
  y: number;
  r?: Path;
};

export type CommandType = "common" | "add" | "delete";

export type EditSequence = {
  text: string;
  type: CommandType;
};

export type Difference = {
  distance: number;
  lcs: string;
  ses: EditSequence[];
};

function addSequence(seq: EditSequence[], edit: EditSequence) {
  const last = seq.at(-1);
  if (last?.type === edit.type) {
    last.text += edit.text;
  } else {
    seq.push(edit);
  }
}

function snake(
  a: string,
  b: string,
  m: number,
  n: number,
  k: number,
  p: number,
  pp: number,
  path: Path[],
): number {
  let y = Math.max(p, pp);
  let x = y - k;
  while (x < m && y < n && a[x] == b[y]) {
    x++;
    y++;
  }

  const offset = m + 1;
  // SES取得のためにどこからsnakeしたかを記録しておく
  path[k + offset] = {
    x,
    y,
    r: p > pp ? path[k - 1 + offset] : path[k + 1 + offset],
  };
  return y;
}

export function difference(a: string, b: string): Difference {
  // アルゴリズムの要件がM <= Nなので、そうじゃない時はswap
  let m: number;
  let n: number;
  let reverse: boolean;
  if (a.length <= b.length) {
    m = a.length;
    n = b.length;
    reverse = false;
  } else {
    m = b.length;
    n = a.length;
    [a, b] = [b, a];
    reverse = true;
  }

  const offset = m + 1;
  const delta = n - m;
  const fp = Array.from(Array(m + n + 3), () => -1);
  const path = Array<Path>(m + n + 3);

  let p = -1;
  do {
    p++;
    for (let k = -p; k <= delta - 1; k++) {
      fp[k + offset] = snake(
        a,
        b,
        m,
        n,
        k,
        fp[k - 1 + offset] + 1,
        fp[k + 1 + offset],
        path,
      );
    }
    for (let k = delta + p; k >= delta + 1; k--) {
      fp[k + offset] = snake(
        a,
        b,
        m,
        n,
        k,
        fp[k - 1 + offset] + 1,
        fp[k + 1 + offset],
        path,
      );
    }
    fp[delta + offset] = snake(
      a,
      b,
      m,
      n,
      delta,
      fp[delta - 1 + offset] + 1,
      fp[delta + 1 + offset],
      path,
    );
  } while (fp[delta + offset] != n);

  const points: Path[] = [];
  for (let p: Path | undefined = path[delta + offset];; p = p.r) {
    if (p == null) {
      break;
    }
    points.push(p);
  }
  points.push({
    x: 0,
    y: 0,
  });
  points.reverse();

  const ses: EditSequence[] = [];
  const lcs: string[] = [];
  let x = 0;
  let y = 0;
  for (let i = 0; i < points.length - 1; i++) {
    const current = points[i];
    const next = points[i + 1];
    let dx = next.x - current.x;
    let dy = next.y - current.y;
    while (dx + dy != 0) {
      if (dx < dy) {
        addSequence(ses, {
          text: b[y],
          type: reverse ? "delete" : "add",
        });
        dy--;
        y++;
      } else if (dx > dy) {
        addSequence(ses, {
          text: a[x],
          type: reverse ? "add" : "delete",
        });
        dx--;
        x++;
      } else {
        addSequence(ses, {
          text: b[y],
          type: "common",
        });
        lcs.push(b[y]);
        dx--;
        dy--;
        x++;
        y++;
      }
    }
  }
  return {
    distance: delta + 2 * p,
    lcs: lcs.join(""),
    ses,
  };
}
