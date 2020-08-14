if exists("g:loaded_growi")
  finish
endif
let g:loaded_growi = 1

let g:growi_api_token = get(g:, "growi_api_token", "")
let g:growi_base_url = get(g:, "growi_base_url", "")
let g:growi_api_path = get(g:, "growi_api_path", "/_api")
let g:growi_is_open_browser = get(g:, "growi_is_open_browser", v:false)

command! -nargs=* -range=% GrowiPushPage <line1>,<line2>call s:pushPage(<q-args>)
command! -nargs=* GrowiGetPage call s:getPage(<q-args>)

function s:inputPath(q, default) abort
  let l:path = input(a:q, a:default)
  if l:path == ""
    let l:path = "/"
  endif

  return l:path
endfunction

function s:inputGrant(q) abort
  let l:grant = confirm(a:q, join(values(map(copy(growi#grant#list()), { k, v -> "&" . k . " " . v })), "\n"))
  if !growi#grant#exist(l:grant)
    throw "illegal grant."
  endif

  return l:grant
endfunction

function s:confirm(q) abort
  return confirm(a:q, "&Yes\n&No") == 1
endfunction

function! s:pushPage(...) range abort
  let l:path = s:inputPath("path: ", get(a:, "1", ""))
  let l:grant = s:inputGrant("grant: ")
  let l:body = join(getline(a:firstline, a:lastline), "\n")
  let l:options = { "grant": l:grant }
  let l:page = growi#page#get(l:path)

  echo "Page \"" . l:path . "\" " . (l:page.ok ? "already exists" : "does not exist") . "."
  if !s:confirm("Push to \"" . g:growi_base_url . l:path . "\" (" . growi#grant#label(l:grant) . ") ?")
    echo "Cancelled."
    return
  endif

  let l:res = growi#page#push(l:path, l:body, l:options)
  if l:res.ok == v:true
    let l:url = g:growi_base_url . l:res.page.path
    echo "Push succeeded: " . l:url

    if exists("g:loaded_openbrowser") && g:loaded_openbrowser == v:true && g:growi_is_open_browser == v:true
      call OpenBrowser(l:url)
    endif
  else
    echoerr get(l:res, "error", "Failed to push.")
  endif
endfunction

function! s:getPage(...) range abort
  let l:path = s:inputPath("path: ", get(a:, "1", ""))

  if !s:confirm("Get the page from \"" . g:growi_base_url . l:path . "\"?")
    echo "Cancelled."
    return
  endif

  let l:res = growi#page#get(l:path)
  if l:res.ok != v:true
    echoerr l:res.error
  else
    execute "enew"
    call append(0, split(l:res.page.revision.body, "\n", v:true))
    if l:res.page.revision.format == "markdown"
      setlocal ft=markdown
    endif
  endif
endfunction
