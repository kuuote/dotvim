call vimrc#denops_loader#load('$VIMDIR/script/gitupdate/dpp_dump.ts'->expand(), v:true)
let s:shot = vimrc#denops_loader#load('$VIMDIR/script/gitupdate/snap/dps_shot.ts'->expand(), v:true)
call denops#request(s:shot, 'run', [['$VIMDIR/script/gitupdate/tasks.json'->expand()], '/data/vim/snapshot'])
