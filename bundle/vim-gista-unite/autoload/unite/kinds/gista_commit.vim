let s:V = gista#vital()
let s:Dict = s:V.import('Data.Dict')

let s:orig = unite#kinds#file_base#define()
let s:kind = {
      \ 'name': 'gista/commit',
      \ 'parents': [
      \   'openable',
      \   'uri',
      \ ],
      \ 'default_action': 'narrow',
      \ 'alias_table' : { 'edit' : 'narrow' },
      \ 'action_table': s:Dict.pick(s:orig.action_table, [
      \   'preview',
      \   'read',
      \   'diff',
      \ ]),
      \}
let s:actions = s:kind.action_table

let s:actions.open = {}
let s:actions.open.description = 'open the selected commit'
let s:actions.open.is_selectable = 1
function! s:actions.open.func(candidates) abort
  for candidate in a:candidates
    if buflisted(candidate.action__path)
      execute 'buffer' bufnr(candidate.action__path)
    else
      let path = unite#util#expand(
            \ fnamemodify(candidate.action__path, ':~:.')
            \)
      call unite#util#smart_execute_command('edit', path)
    endif
    call unite#remove_previewed_buffer_list(bufnr(candidate.action__path))
  endfor
endfunction

let s:actions.narrow = {}
let s:actions.narrow.description = 'narrow the selected commit'
let s:actions.narrow.is_quit = 0
let s:actions.narrow.is_start = 1
function! s:actions.narrow.func(candidate) abort
  let context = {}
  let context.source__gist = a:candidate.action__gist
  call unite#start_script([['gista/file']], context)
endfunction


function! unite#kinds#gista_commit#define() abort
  return s:kind
endfunction
call unite#define_kind(s:kind)
