let s:V = vital#growi#new()
let s:HTTP = s:V.import("Web.HTTP")
let s:JSON = s:V.import("Web.JSON")

let s:grant_list = {
\ "public": 1,
\ "restricted": 2,
\ "specified": 3,
\ "owner": 4
\}

function! growi#doRequest(method, path, data) abort
  if get(g:, "growi_access_token", v:null) == v:null
    throw "Failed to get access token."
  endif

  if get(g:, "growi_base_url", v:null) == v:null
    throw "Failed to get growl url."
  endif

  let s:data = a:data
  let s:data.access_token = g:growi_access_token

  let s:param = {}
  let s:body = {}
  let s:headers = {}

  if toupper(a:method) == "GET"
    let s:param = s:data
  else
    let s:body = s:JSON.encode(s:data)
    let s:headers = {
    \ "Content-Type": "application/json"
    \}
  endif

  let s:res = s:HTTP.request(
  \ g:growi_base_url . g:growi_api_path . a:path,
  \ {
  \   "method": a:method,
  \   "param": s:param,
  \   "data": s:body,
  \   "headers": s:headers
  \ }
  \)

  if s:res.status == 403
    throw "Authentication failed."
  endif

  return s:JSON.decode(s:res.content)
endfunction

function! growi#grant(grant) abort
  return get(s:grant_list, a:grant, v:null)
endfunction
