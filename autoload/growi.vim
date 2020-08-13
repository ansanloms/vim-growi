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

  let s:data = a:data
  let s:data.access_token = g:growi_api_token

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

