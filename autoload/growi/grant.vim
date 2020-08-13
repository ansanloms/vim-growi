let s:grant_list = {
\ 1: "public",
\ 2: "restricted",
\ 3: "specified",
\ 4: "owner"
\}

function! growi#grant#list() abort
  return s:grant_list
endfunction

function! growi#grant#exist(grant) abort
  return match(keys(s:grant_list), a:grant) > -1
endfunction

function! growi#grant#label(grant) abort
  return growi#grant#exist(a:grant) ? s:grant_list[a:grant] : v:null
endfunction
