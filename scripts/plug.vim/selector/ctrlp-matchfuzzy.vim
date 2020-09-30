call minpac#add('mattn/ctrlp-matchfuzzy',{'type': 'opt'})

silent! packadd ctrlp-matchfuzzy
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'} 
