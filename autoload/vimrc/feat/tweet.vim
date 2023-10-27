function s:read()
	try
		return readfile(t:vimrc_tweet_path)
	catch
		return []
	endtry
endfunction

function s:tweet()
  if confirm("呟くわよ?", "&Yes\n&No", 2) == 1
		let head = getline(1, '$')->filter('v:val !~# "^\\s*$"')
		let tail = s:read()
		call writefile(head + [''] + tail, t:vimrc_tweet_path)
		let previous = max([1, tabpagenr() - 1])
		tabclose
		execute 'tabnext' previous
    " suppress hit enter
    redraw
    echo 'Done'
	endif
endfunction

" タブを切る。保存すると呟ける。以上
function vimrc#feat#tweet#open(path) abort
	tabnew
  let t:vimrc_tweet_path = a:path
	setlocal buftype=nofile bufhidden=wipe noswapfile
	call setline(1, s:read())
	execute (&lines / 4) .. 'new' '/tmp/tweet.txt'
	augroup vimrc_local#tweet
		autocmd!
		autocmd BufWritePost <buffer> call s:tweet()
	augroup END
endfunction
