function vimrc#autocmd#shebang#do() abort
  if stridx(getline(1), '#!/') != 0
    return
  endif
  let file = expand('<afile>')
  let perm = getfperm(file)
  let orw = perm[0:1]
  let grw = perm[3:4]
  let urw = perm[6:7]
  let newperm = orw .. 'x' .. grw .. 'x' .. urw .. 'x'
  if perm !=# newperm
    try
      call setfperm(file, newperm)
      echo 'Set executable: ' .. file
    catch
    endtry
  endif
endfunction
