# open-close.vim

This plugin tweaks the neovim open and close behavior, and provides some helper functions. Since it changes the behavior of things like file tree plugins, it does a _little more_ than just _open and close_.

## Installation

```vim
Plug 'alichtman/open-close.vim'

# Depends on one of...
Plug 'scrooloose/nerdtree'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
```

## Configuration

You can pick between NERDTree or CHADTree to open at startup if you run vim without a file argument.

```vim
let g:open_close_use_NERDTree = 1
let g:open_close_use_CHADTree = 1
```

CHADTree is used by default.

The `ToggleFileTree()` function is provided by this plugin. It's mapped to `Ctrl-n` by default. You can set the following to prevent the remap:

```vim
let g:open_close_dont_remap_toggle_file_tree = 1
```
