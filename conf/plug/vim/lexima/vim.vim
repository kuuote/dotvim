" 変数のprefixの:をスペースで打てるようにしてみる
call lexima#add_rule({'char': '<Space>', 'at': '\<[bwtglsav]\%#', 'input': ':', 'filetype': 'vim'})
