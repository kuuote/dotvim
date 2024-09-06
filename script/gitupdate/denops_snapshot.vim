call vimrc#denops_loader#load('$MYVIMDIR/script/gitupdate/dpp_dump.ts'->expand(), v:true)
let s:shot = vimrc#denops_loader#load('$MYVIMDIR/script/gitupdate/snap/dps_shot.ts'->expand(), v:true)
call denops#request(s:shot, 'run', [['$MYVIMDIR/script/gitupdate/tasks.json'->expand()], '/data/vim/snapshot'])
