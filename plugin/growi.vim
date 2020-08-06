if exists("g:loaded_growi")
  finish
endif
let g:loaded_growi = 1

let g:growi_access_token = get(g:, "growi_access_token", "")
let g:growi_base_url = get(g:, "growi_base_url", "")
let g:growi_api_path = get(g:, "growi_api_path", "/_api")
let g:growi_default_grant = get(g:, "growi_default_grant", "public")
let g:growi_default_base_path = get(g:, "growi_default_base_path", "")
let g:growi_is_open_browser = get(g:, "growi_is_open_browser", v:false)

command! -nargs=+ -range=% GrowiPushPage <line1>,<line2>call s:pushPage(<q-args>)
command! -nargs=1 GrowiGetPage call s:getPage(<q-args>)

function! s:pushPage(...) range abort
  let s:path = g:growi_default_base_path . get(a:, "1", "")
  let s:grant = growi#grant(get(a:, "2", g:growi_default_grant))
  let s:is_open_browser = get(a:, "3", g:growi_is_open_browser)

  if s:path == ""
    throw "illegal page path."
  endif

  if s:grant == v:null
    throw "illegal grant."
  endif

  let s:res = growi#page#push(s:path, join(getline(a:firstline, a:lastline), "\n"), { "grant": s:grant })

  if s:res.ok == v:true
    let s:url = g:growi_base_url . s:res.page.path
    echo "push succeeded: " . s:url

    echo s:is_open_browser
    echo g:loaded_openbrowser
    if s:is_open_browser == v:true && exists("g:loaded_openbrowser") && g:loaded_openbrowser
      call OpenBrowser(s:url)
    endif
  else
    echoerr "push failed."
  endif
endfunction

function! s:getPage(...) range abort
  let s:path = g:growi_default_base_path . get(a:, "1", "")

  if s:path == ""
    throw "illegal page path."
  endif

  let s:res = growi#page#get(s:path)
  if s:res.ok == v:true
    execute "split" "growi:/" . s:res.page.path
    call append(0, split(s:res.page.revision.body, "\n", v:true))
    if s:res.page.revision.format == "markdown"
      setlocal ft=markdown
    endif
  else
    echoerr s:res.error
  endif
endfunction

