import { EditSequence } from "./onp.ts";

export type HighlightInfo = Omit<EditSequence, "text"> & {
  col: number;
  width: number;
};

export type Highlightable = {
  info: HighlightInfo[];
  text: string;
};

// ハイライト情報をくっつけたり元のテキストで置き換えたり(ignoreCase用)するやつ
export function highlightable(
  ses: EditSequence[],
  a: string,
  b: string,
  includeDelete: boolean,
): Highlightable {
  const info: HighlightInfo[] = [];

  let text = "";
  let textLength = 0;
  let ac = 0;
  let bc = 0;
  for (const seq of ses) {
    const newLength = new TextEncoder().encode(seq.text).length;
    if (includeDelete || seq.type !== "delete") {
      info.push({
        ...seq,
        col: textLength,
        width: newLength,
      });
    }
    if (seq.type === "common") {
      text += b.slice(
        bc,
        bc + seq.text.length,
      );
      ac += seq.text.length;
      bc += seq.text.length;
    } else if (seq.type === "add") {
      text += b.slice(
        bc,
        bc + seq.text.length,
      );
      bc += seq.text.length;
    } else if (seq.type === "delete" && includeDelete) {
      text += a.slice(
        ac,
        ac + seq.text.length,
      );
      ac += seq.text.length;
    }
    textLength += newLength;
  }

  return {
    info,
    text,
  }
}
