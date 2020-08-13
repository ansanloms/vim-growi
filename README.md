# vim-growi

[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)

This plugin edits [GROWI](https://growi.org/) pages from vim.

## Installing

```vim
Plug 'ansanloms/vim-growi'

" Required to open the browser after pushing the page to GROWI.
Plug 'tyru/open-browser.vim'
```

## Settings

```vim
" GROWI API token.
let g:growi_api_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

" GROWI site URL.
let g:growi_base_url = "https://my.growi.cloud/"

" GROWI API base path.
" default: /_api
let g:growi_api_path = "/_api"

" Open the browser after pushing the page to GROWI.
" default: false
" Requires: https://github.com/tyru/open-browser.vim
let g:growi_is_open_browser = v:true
```

## Commands

Get GROWI Page:

```vim
:GrowiGetPage <path>
```

Push GROWI Page:

```vim
:GrowiPushPage <path>
```

## License

MIT
