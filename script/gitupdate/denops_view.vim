" tabedit $VIMDIR/script/gitupdate/denops_view.vim

if !glob('/data/vim/diff/**/*.diff', 1, 1)->empty()
  throw 'diff残ってんぞ'
endif

call vimrc#denops_loader#load('$VIMDIR/script/gitupdate/dpp_dump.ts'->expand(), v:true)

let s:runner = vimrc#denops_loader#load('$VIMDIR/script/gitupdate/denops_view.ts'->expand())
let s:shot = vimrc#denops_loader#load('$VIMDIR/script/gitupdate/snap/dps_shot.ts'->expand())
let s:diff = vimrc#denops_loader#load('$VIMDIR/script/gitupdate/snap/dps_diff.ts'->expand())

let s:tasks = []
call add(s:tasks, '$VIMDIR/script/gitupdate/a.json'->expand())
call add(s:tasks, '$VIMDIR/script/gitupdate/tasks.json'->expand())

call denops#plugin#wait(s:shot)
call denops#request(s:shot, 'run', [s:tasks, '/data/vim/snapshot'])

augroup gitupdate_denops_view
  autocmd!
  autocmd User GitUpdatePre :
  autocmd User GitUpdatePost call vimrc#dpp#makestate_job()
  autocmd User GitUpdatePost call denops#plugin#wait(s:diff)
  autocmd User GitUpdatePost call denops#notify(s:diff, 'run', ['/data/vim/snapshot'])
  " set ls=2 | nnoremap @ <pagedown> | nnoremap del <Cmd>DeleteIt<CR><Cmd>tabclose<CR> | eval glob('/data/vim/diff/**/*.diff', 1, 1)->map('execute("tabedit " .. v:val, "")')
augroup END

call denops#plugin#wait(s:runner)
call denops#request(s:runner, 'run', [s:tasks, './task/fget.sh'])
