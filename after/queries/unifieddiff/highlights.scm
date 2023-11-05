; from https://github.com/monaqa/tree-sitter-unifieddiff/blob/9f2f60b294e3c6dd1116e374343de25c45db86a0/queries/highlights.scm
(git_diff_header) @type

[
  (git_old_mode)
  (git_new_mode)
  (git_deleted_file_mode)
  (git_new_file_mode)
  (git_copy_from)
  (git_copy_to)
  (git_rename_from)
  (git_rename_to)
  (git_similarity_index)
  (git_dissimilarity_index)
  (git_index)
] @preproc

(from_file_line) @text.diff.delsign
(to_file_line) @text.diff.addsign

(hunk_info) @keyword @text.underline
(hunk_comment) @text.emphasis @text.quote

(line_nochange) @comment
(line_nochange " " @text.diff.indicator)

(line_deleted "-" @text.diff.indicator @text.diff.delsign)
(line_deleted (body) @text.diff.delete)

(line_added "+" @text.diff.indicator @text.diff.addsign)
(line_added (body) @text.diff.add)
