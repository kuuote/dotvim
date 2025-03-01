call vimrc#denops_loader#load('$VIMCONF/script/gitupdate/dpp_dump.ts'->expand(), v:true)
let s:shot = vimrc#denops_loader#load('$VIMCONF/script/gitupdate/snap/dps_shot.ts'->expand(), v:true)
call denops#request(s:shot, 'run', [['$VIMCONF/script/gitupdate/tasks.json'->expand()], '/data/vim/snapshot'])
