" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/landonb/dubs_file_finder
" License: GPLv3
" Summary: Command-T and CtrlP config and customize
" -------------------------------------------------------------------
" Copyright © 2009, 2015-2018, 2024 Landon Bouma.

" ABOUT:
"
"   Command-T is a great tool for quickly finding and opening
"   project files.
"
"   This script wraps Command-T so it's available from <Leader>t
"   and opens a predefined project path.
"
"   This script doesn't require you to enter a target directory.
"   Rather, you'll want to create a `cmdt_paths` directory
"   somewhere in your Vim folder (or create a same-named symlink),
"   and you'll want to populate that directory with symlinks to all
"   of your projects.
"
"   In this manner, it's just one key-combo to invoke Command-T,
"   and you don't have to specify the directory to scan. You might
"   be concerned that listing all projects' files together will make
"   it harder to find the file you want, but Command-T is such a great
"   tool that even with thousands of source files, it's still a cinch to
"   find and open files.

" CXREF:
"
"   ~/.vim/pack/ctrlpvim/start/ctrlp.vim
"   ~/.vim/pack/wincent/start/command-t

if exists("g:plugin_dubs_file_finder") || &cp
  finish
endif
let g:plugin_dubs_file_finder = 1

" -------------------------------------------------------------------

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" File Navigation/search using :find
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Using :set path= and :find
" ^^^^^^^^^^^^^^^^^^^^^^^^^^

" Vim has a built-in :find command, but it doesn't implement
" partial or fuzzy finding like Command-T, and it's tedious
" to have to setup 'path' to list all your project directories.
"
" Regardless, here's roughly how it works:
"
" - The default path includes the current directory, /usr/include, and
"   a trailing comma which also indicates the current directory. E.g.,
"
"     path=.,/usr/include,,
"
" - You can add additional paths for find to search. E.g.,
"
"     let &path = &path . "," . "/path/to/source/**"
"     ...
"
" - Use double-stars to include sub-directories, up to 30 levels deep.
"
" - After setting up the path, use :find to open files...
"   but it's just not as good as Command-T.
"
" - See :h file-searching, :h find, :h args, :h argadd.

" -------------------------------------------------------------------

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" File Navigation/search using Command-T
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Command-T
" ^^^^^^^^^^
" 
" https://github.com/wincent/Command-T

" BUILD:
"
" - How to install Command-T as a normal Vim plugin:
"
"   mkdir -p ~/.vim/pack/wincent/start
"   cd ~/.vim/pack/wincent/start
"   git clone https://github.com/wincent/command-t.git
"
" - How to build Command-T:
"
"   sudo apt-get install ruby-dev
"   cd ~/.vim/pack/wincent/start/command-t/ruby/command-t
"   ruby extconf.rb
"   make
"
" - How to create help tags:
"
"   :Helptags ~/.vim/pack/wincent/start/command-t/doc
"
" USAGE:
"
" - How to start Command-T:
"
"   :CommandT <some/dir>    — Open Command-T, starting in some/dir/
"
"   <Leader>t               — Open Command-T, starting in path/to/cmdt_paths/
"
" - Useful Command-T commands:
"
"   <C-f>                   — Regenerate the file list (flush the cache)
"
" REFER:
"
"   :h command-t
"   :h command-t-ruby

" Command-T v6 is NeoVim-only Lua rewrite.
" - Opt-in to previous Ruby implementation.
let g:CommandTPreferredImplementation='ruby'

" Walk up directory from file's base and look for .git, etc,
" when starting Command-T using the current file's location.
"  See: g:CommandTSCMDirectories ('.git,.hg,.svn,.bzr,_darcs')
let g:CommandTTraverseSCM = "file"

" Always include dot-files, otherwise they're excluded by default
" and only included if you use a dot as part of the query.
let g:CommandTAlwaysShowDotFiles = 1

" Similary always scan dot directories (which are excluded regardless
" of you typing a complete dot-prefixed directory name).
let g:CommandTScanDotDirectories = 1

" Increase file limit maximum to avoid breaching it, e.g.,
"     Warning: maximum file limit reached
" - You can increase the limit by changing a command-t global, e.g.,
"     let g:CommandTMaxFiles=200000
" - Or you can suppress the warning by changing a different global, e.g.,
"     let g:CommandTSuppressMaxFilesWarning=1
" - For best performance, consider using a 'fast' scanner (like 'find',
"   and not the built-in, default 'ruby' scanner); see:
"     :help g:CommandTFileScanner
let g:CommandTMaxFiles=1000000

" Use a 'fast' scanner.
" - The 'ruby' scanner works everywhere but may not be that fast.
" - The 'git' scanner uses git-ls-files to generate file lists, but
"   we don't want that limitation.
" - There's also a 'watchman' scanner not discussed any further here.
"     https://github.com/facebook/watchman
" - The 'find' scanner uses the built-in system command, and works
"   well on Linux and macOS.
let g:CommandTFileScanner = "find"

" -------------------------------------------------------------------

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" File Navigation/search using CtrlP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" CtrlP
" ^^^^^
"
" https://github.com/kien/ctrlp.vim

" CtrlP is similar to Command-T. Most people just use one or the other.
" I've included both herein so you can get a taste of both, if you want.

" BUILD:
"
" - How to install CtrlP as a normal Vim plugin:
"
"   mkdir -p ~/.vim/pack/kien/start
"   cd ~/.vim/pack/kien/start
"   git clone https://github.com/kien/ctrlp.vim.git
"
" - How to create help tags:
"
"   :Helptags ~/.vim/pack/kien/start/ctrlp.vim/doc
"
" USAGE:
" 
" - How to start CtrlP:
"
"   :CtrlP <some/dir>       — Open CtrlP, starting in some/dir/
"
" - Useful CtrlP commands:
"
"   <F5>                    — Regenerate the file list
"
" BWARE: CtrlP won't find the file from which the command was run,
"        so don't get trapped by searching for the file that's active.
"
" REFER:
"
"   :help ctrlp.txt
"   :help ctrlp-options

" Enable CtrlP.
" - SAVVY/2015-01-27: Other code expects first entry of &rtp to be ~/.vim,
"                     so use += to append and not ^= to prepend.
set runtimepath+=~/.vim/pack/kien/start/ctrlp.vim

" One Command-T to Rule Them All
" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

" DEVs: Populate the cmdt_paths directory with a bunch of symlinks
"       and use Ctrl-E to invoke Command-T. It's a snap!

" Here we override Ctrl-D, because that's a very valuable key combination
" and it's current inhabitant is frittering away its opportunity to be
" useful. Specifically, Ctrl-D is redundant (replaced by more common keys),
" and it's also non-conformist: it performs a different action in different
" modes. Since we intend to use Command-T whenever we feel like it, we'll
" map it to all modes of Ctrl-D.
"
" A little history:
"
"   In Command mode, Ctrl-U and Ctrl-D page up and down, respectively;
"                    Ctrl-E and Ctrl-Y scroll the window up or down one line.
"                    Except in mswin mode, then Ctrl-Y is remapped to Redo.
"
"   In Insert mode, Ctrl-U deletes to beginning of line,
"                   Ctrl-D doesn't seem to do anything?
"                   Ctrl-E copies the character one line beneath the cursor
"                   to the current line, so you can mirror the next line.
"                     EXPLAIN: Where is Ctrl-E mapped or documented?
"                   Ctrl-Y makes my screen blip.
"
"   If you've installed Dubs Vim,
"                   You can scroll the window by one line with <Ctrl-Up/Down>,
"                   and you can page up and down with <PageUp> and <PageDown>.
"
" As you can see, the navigation commands only work in command mode, and
" one of them is already remapped. Also, in insert mode. Ctrl-D doesn't
" seem used. So we might as well map it for both modes to mean Directory
" File Search or something -- just remember, Ctrl-D for directories, i.e.,
" I want to find a file in some directory somewhere.

" We don't require that the cmdt_paths directory be in any one
" particular location, or even that it be so named, so long as
" we can find it amongst your Vim files.

if !exists("dubs_file_finder_alert_pending")
  let g:dubs_file_finder_alert_pending = 0
endif

" FIXME: Make DRY. This fcn. was copied from dubs_grep_steady.
let s:ffdir = finddir("cmdt_paths", pathogen#split(&rtp)[0] . "/**")
if s:ffdir != ''
  let s:ffdir = fnamemodify(s:ffdir, ":p:h")
else
  " No file, but there should be a template we can copy.
  let s:tmplate = finddir('cmdt_paths.template',
                          \ pathogen#split(&rtp)[0] . "/**")
  if s:tmplate != ''
    let s:tmplate = fnamemodify(s:tmplate, ":p")
    " Get the filename root, i.e., drop the ".template",
    " but first remove the trailing slash.
    let s:sepr = pathogen#slash()
    let s:ffdir = substitute(s:tmplate, s:sepr.'$', '', 'g')
    let s:ffdir = fnamemodify(s:ffdir, ":r")
    " Make a copy of the template.
    if has('macunix')
      " Default macOS BSD cp's -a same as -pPR, and -r and -R mutually exclusive.
      " - On linux (has('unix')?), GNU -a same as -dR.
      silent execute '!/bin/cp -a ' . s:tmplate . ' ' . s:ffdir
    else
      " Linux/GNU cp.
      silent execute '!/bin/cp -ra ' . s:tmplate . ' ' . s:ffdir
    endif
    " We're initially called on startup when it's a bad idea to alert
    " the user -- they haven't done anything yet.
    let g:dubs_file_finder_alert_pending = 1
  else
    echomsg 'Warning: Dubs Vim could not find cmdt_paths.template'
  endif
endif

command -nargs=? -complete=dir DubsFileFindrWarnTell
  \ call DubsFileFindrWarnTellDo(<q-args>)
function DubsFileFindrWarnTellDo(path)
  "echomsg 'Notice: path: ' . a:path . ' / s:ffdir ' . s:ffdir
  if g:dubs_file_finder_alert_pending == 1
    "echomsg 'Notice: To use <Ctrl-D>, add symlinks to ' . s:ffdir
    call confirm('Notice: To use <Ctrl-D>, add symlinks to ' . s:ffdir)
    let g:dubs_file_finder_alert_pending = 0
  endif
  " LATER: Latest wincent/command-t v6 Lua rewrite's CommandT does
  " not accept path arg. Might try this instead if this plugin
  " upgraded to NeoVim/Lua plug:
  "   lcd a:path
  "   call CommandT
  execute ':CommandT ' . a:path
endfunction

if s:ffdir != ''

  " All The modes:
  "   Normal
  "   Visual and Select
  "   Operator-pending
  "   Insert
  "   Command-line.
  " 2018-05-07: (lb): WRONG WRONG WRONG: Do not hide Vim's Ctrl-D, which unindents.
  " Instead, just rely on <Leader>d, which CommandT already maps for us.
  " NOTE: <C-S-D> doesn't work! But <Leader>D is different than <Leader>d!!
  "execute "nnoremap <C-D>       :DubsFileFindrWarnTell " . s:ffdir . "<CR>"
  "execute "vnoremap <C-D> :<C-U>:DubsFileFindrWarnTell " . s:ffdir . "<CR>"
  "execute "onoremap <C-D>  <C-C>:DubsFileFindrWarnTell " . s:ffdir . "<CR>"
  "execute "inoremap <C-D>  <C-O>:DubsFileFindrWarnTell " . s:ffdir . "<CR>"
  "execute "cnoremap <C-D>  <C-C>:DubsFileFindrWarnTell " . s:ffdir . "<CR>"

  " 2018-05-17: (lb): I keep running <leader>t, which takes a while to load,
  " and isn't the cmdt_paths/ directory (not sure what the default dir is).
  " So just remap Command T's <leader>t.
  "execute "map <silent> <leader>d :DubsFileFindrWarnTell " . s:ffdir . "<CR>"
  execute "map <silent> <leader>t :DubsFileFindrWarnTell " . s:ffdir . "<CR>"

  " Warn-Tell the user if they've got multiple file finder directories.

  " FIXME
"  let dcnt = finddir("cmdt_paths", pathogen#split(&rtp)[0] . "/**", -1)
"  if (dcnt > 1)
"    call confirm('Warning: found ' . dcnt . ' cmdt_paths directories.',
"               \ 'OK')
"  endif
else
  call confirm('Warning: Did not find a cmdt_paths directory.', 'OK')
endif

" ------------------------------------------

function! s:SetCtrlPUserCommandRg()
  let g:ctrlp_user_command = 'rg %s --files-with-matches --color=never'
endfunction

function! s:SetCtrlPUserCommandAg()
  " -l --files-with-matches Only print the names of files containing
  "                         matches, not the matching lines....
  " -g PATTERN              Print filenames matching PATTERN.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endfunction

function! s:SetCtrlPUserCommand()
  " Speed up fuzzy file finding -- and respect .ignore and .gitignore rules!
  if executable("rg")
    call s:SetCtrlPUserCommandRg()
  elseif executable("ag")
    call s:SetCtrlPUserCommandAg()
  " else, nothing special, probably falls back to grep or find.
  endif
endfunction

" FIXME/2018-05-06: (lb): Should probably function-ize everything
" and make a main().
" FIXME/2020-02-04: (lb): And move most code under autoload/.
call s:SetCtrlPUserCommand()

