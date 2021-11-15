command! -range -nargs=0 EXA <line1>,<line2>call exasterisk#get_selection_char()
command! -range -nargs=0 EXAA <line1>,<line2>call exasterisk#search_selection_char()

nnoremap <Space>o :EXA<CR>
vnoremap <Space>o :EXAA<CR>



