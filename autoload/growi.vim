let s:V = vital#growi#new()
let s:HTTP = s:V.import("Web.HTTP")
let s:JSON = s:V.import("Web.JSON")

function! growi#doRequest(method, path, data) abort
  if get(g:, "growi_api_token", v:null) == v:null
    throw "Failed to get GROWI API token."
  endif

  if get(g:, "growi_base_url", v:null) == v:null
    throw "Failed to get GROWI site url."
  endif

  let l:data = a:data
  let l:data.access_token = g:growi_api_token

  let l:param = {}
  let l:body = {}
  let l:headers = {}

  if toupper(a:method) == "GET"
    let l:param = l:data
  else
    let l:body = s:JSON.encode(l:data)
    let l:headers = {
    \ "Content-Type": "application/json"
    \}
  endif

  let l:res = s:HTTP.request(
  \ g:growi_base_url . g:growi_api_path . a:path,
  \ {
  \   "method": a:method,
  \   "param": l:param,
  \   "data": l:body,
  \   "headers": l:headers
  \ }
  \)

  if l:res.status == 403
    throw "Authentication failed."
  endif

  return s:JSON.decode(l:res.content)
endfunction
