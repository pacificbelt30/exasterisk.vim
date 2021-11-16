let s:escape_char = ["*","/","\""]
" 選択部分の文字列を取得
function! exasterisk#get_selection_char() range
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    echo '選択箇所なし'
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - 1]
  let lines[0] = lines[0][column_start - 1:]
  echo join(lines, "\n")
  return join(lines, "\n")
endfunction

" 選択箇所を検索 and レジスタに登録
function! exasterisk#search_selection_char() range
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    echo '選択箇所なし'
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - 1]
  let lines[0] = lines[0][column_start - 1:]
  echo join(lines, "\n")
  "execute '/'.join(lines, "\n").''
  let l:search_char = join(lines,"\\n")
  for s in s:escape_char
    let l:search_char = substitute(search_char,"\\".s,"\\\\".s,"g")
  endfor
  echo l:search_char
  try
    execute '/'.l:search_char
    let @/ = l:search_char
  catch
    echo l:search_char."が見つかりませんでした"
  endtry
  ":call search('/'.join(lines,"\\n"))
endfunction
