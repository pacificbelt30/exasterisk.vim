"特殊文字一覧 ^ $ . * [ ] / ~ \
let s:escape_char = ["*","/","$",".","[","]","~","\""]
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
" searchposとかいう関数があった
function! exasterisk#search_selection_char() range
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  echo getpos("'>")
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    echo '選択箇所なし'
    return ''
  endif
  "let lines[-1] = lines[-1][: column_end-1]
  let lines[-1] = join([lines[-1][: column_end - 2] ,nr2char(strgetchar(lines[-1],charidx(lines[-1],column_end - 1)))],"")
  "echo lines[-1]
  let lines[0] = lines[0][column_start - 1:]
  echo join(lines, "\n")
  "execute '/'.join(lines, "\n").''

  " 検索文字列を生成(特殊文字をエスケープする)
  let l:search_char = join(lines,"\\n")
  let l:count = 0
  for l in lines
    for s in s:escape_char
      let lines[l:count] = substitute(lines[l:count],"\\".s,"\\\\".s,"g") " 配列の要素でも代入するときはletを使う
    endfor
    let l:count = l:count + 1
  endfor
  let l:search_char = join(lines,"\\n")
  "echo l:search_char

  " 検索実行
  try
    "execute "normal" . '/'.l:search_char
    let @/ = l:search_char
    "normal n
    "execute 'set hlsearch' " 光らない
  catch
    echo l:search_char."が見つかりませんでした"
  endtry
  ":call search('/'.join(lines,"\\n"))
endfunction
