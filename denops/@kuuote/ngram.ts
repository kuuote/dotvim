export type Trie = {
  next: Record<string, Trie>;
  start: number;
  len: number;
};

/*

ngramをベースとした曖昧マッチ&スコアリングプログラム
入力をhogeとして
- hoge
- oge
- ge
- e
のように分解してTrieを構築、任意長でこれと文字列をマッチすると入力の一部分からなるマッチ情報が手に入る
- Trieの構築を除くと実行効率多分O(n)くらい？

*/

export type Needle = {
  trie: Trie;
  length: number;
};

export function makeTrie(input: string): Needle {
  const root: Trie = {
    next: {},
    start: -1,
    len: 0,
  };
  for (let start = 0; start < input.length; start++) {
    const pinput = input.slice(start);
    let current = root;
    for (let i = 0; i < pinput.length; i++) {
      const c = pinput[i];
      // 重複した場合に末尾の候補を優先したいので上書きする。
      // 例えばhogepiyoを絞り込んだ後、改めてpiyoを前に持ってきたかったら、
      // 再びpiyoを打てば実現できるようにしたい
      current.next[c] = {
        next: current.next[c]?.next ?? {},
        start,
        len: i + 1,
      };
      current = current.next[c];
    }
  }
  return {
    trie: root,
    length: input.length,
  };
}

export type MatchResult = {
  start: number;
  len: number;
  text: string;
  needleStart: number;
};

export type Result = {
  matches: MatchResult[];
  score: number;
};

export type MatchOptions = {
  minMatchLength?: number;
};

export function match(
  input: string,
  needle: Needle,
  options: MatchOptions = {},
): Result {
  const matches: MatchResult[] = [];
  const root = needle.trie;
  let current = root;
  const score = Array(needle.length).fill(0);

  // 終了後にチェックするのがめんどいので末尾+1まで処理させる
  for (let i = 0; i <= input.length; i++) {
    const c = input[i];
    if (current.next[c] == null) {
      if (current.len != 0) {
        const len = current.len;
        const start = i - current.len;
        if (options.minMatchLength ?? 1 <= len) {
          matches.push({
            start,
            len,
            text: input.slice(start, start + len),
            needleStart: current.start,
          });
          // 類似度と言っても、重複の多い文字列が優先されるのも嬉しくないので
          // score matrixっぽいことをやってみる
          for (let i = current.start; i < current.start + len; i++) {
            score[i] = Math.max(score[i], len);
          }
        }
      }
      current = root;
    }
    if (current.next[c] != null) {
      current = current.next[c];
    }
  }
  return {
    matches,
    score: score.reduce((a, b) => a + b),
  };
}

