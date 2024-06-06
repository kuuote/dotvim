// Note: Currently can't use type declare in npm import at `deno lsp`
type FzfResult<T> = {
  item: T;
  positions: Set<number>;
  score: number;
};

type FzfOptions<T> = {
  selector?: (item: T) => string;
  sort?: boolean;
};

export declare class Fzf<T> {
  constructor(items: T[], options: FzfOptions<T>);
  find(key: string): FzfResult<T>[];
}
