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
  let s:path = input(a:q, a:default)
  if s:path == ""
    let s:path = "/"
  endif

  return s:path
endfunction

function s:inputGrant(q) abort
  let s:grant = confirm(a:q, join(values(map(copy(growi#grant#list()), { k, v -> "&" . k . " " . v })), "\n"))
  if !growi#grant#exist(s:grant)
    throw "illegal grant."
  endif

  return s:grant
endfunction

function s:confirm(q) abort
  return confirm(a:q, "&Yes\n&No") == 1
endfunction

function! s:pushPage(...) range abort
  let s:path = s:inputPath("path: ", get(a:, "1", ""))
  let s:grant = s:inputGrant("grant: ")
  let s:body = join(getline(a:firstline, a:lastline), "\n")
  let s:options = { "grant": s:grant }
  let s:page = growi#page#get(s:path)

  echo "Page \"" . s:path . "\" " . (s:page.ok ? "already exists" : "does not exist") . "."
  if !s:confirm("Push to \"" . g:growi_base_url . s:path . "\" (" . growi#grant#label(s:grant) . ") ?")
    echo "Cancelled."
    return
  endif

  let s:res = growi#page#push(s:path, s:body, s:options)
  if s:res.ok == v:true
    let s:url = g:growi_base_url . s:res.page.path
    echo "Push succeeded: " . s:url

    if exists("g:loaded_openbrowser") && g:loaded_openbrowser == v:true && g:growi_is_open_browser == v:true
      call OpenBrowser(s:url)
    endif
  else
    echoerr get(s:res, "error", "Failed to push.")
  endif
endfunction

function! s:getPage(...) range abort
  let s:path = s:inputPath("path: ", get(a:, "1", ""))

  if !s:confirm("Get the page from \"" . g:growi_base_url . s:path . "\"?")
    echo "Cancelled."
    return
  endif

  let s:res = growi#page#get(s:path)
  if s:res.ok != v:true
    echoerr s:res.error
  else
    execute "enew"
    call append(0, split(s:res.page.revision.body, "\n", v:true))
    if s:res.page.revision.format == "markdown"
      setlocal ft=markdown
    endif
  endif
endfunction

