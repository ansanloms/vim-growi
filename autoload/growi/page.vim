function! growi#page#get(path) abort
  return growi#doRequest("GET", "/pages.get", { "path": a:path })
endfunction

function! growi#page#create(path, body, options) abort
  return growi#doRequest("POST", "/pages.create", {
    \ "path": a:path,
    \ "body": a:body,
    \ "grant": get(a:options, "grant", 1)
    \})
endfunction

function! growi#page#update(page_id, revision_id, body, options) abort
  return growi#doRequest("POST", "/pages.update", {
    \ "page_id": a:page_id,
    \ "revision_id": a:revision_id,
    \ "body": a:body,
    \ "grant": get(a:options, "grant", 1)
    \})
endfunction

function! growi#page#push(path, body, options) abort
  let l:page = growi#page#get(a:path)

  let l:res = l:page.ok == v:true ?
    \ growi#page#update(l:page.page._id, l:page.page.revision._id, a:body, a:options) :
    \ growi#page#create(a:path, a:body, a:options)

  return l:res.ok == v:true ?
    \ growi#page#get(a:path) :
    \ l:res
endfunction
