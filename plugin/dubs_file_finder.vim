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
"   ~/.vim/pack/ctrlpvim/opt/ctrlp.vim
"   ~/.vim/pack/wincent/opt/command-t

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

function! s:SetupCommandTPlainVim()
  " SPIKE: Demo in NeoVim.
  " - Verify dot directories are scanned.
  if has('nvim')
    " Try the Lua tooling.
    " - ignore_case = nil,  — If nil, will infer from Neovim's 'ignorecase'
    "   smart_case = nil,   — If nil, will infer from Neovim's 'smartcase'
    require('wincent.commandt').setup({
      \ always_show_dot_files = true,
      \ never_show_dot_files = false,
      \ ignore_case = nil,
      \ smart_case = nil,
    \ })

    return
  endif

  " Command-T v6 is NeoVim-only Lua rewrite.
  " - Opt-in to previous Ruby implementation.
  let g:CommandTPreferredImplementation="ruby"

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
endfunction

call s:SetupCommandTPlainVim()

" -------------------------------------------------------------------

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Command-T <Leader>t Binding
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Combined Project Command-T Binding
" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

" The legacy :CommandT command takes a path arg, e.g.,
"
"     :CommandT path/to/project
"
" - To use this functionality in Command-T v6, you must opt-in:
"
"     g:CommandTPreferredImplementation='ruby'
"
" - That's because the default :CommandT functionality in v6
"   (aka Lua Command-T) eschews args and uses the current dir.
"
"   - So we'd have to call, e.g., :lcd first before v6's :CommandT
"
"   - But we don't, because we opt-in to the legacy behavior,
"     so we rely on passing a path argument.
"
" For our binding, we don't want to bug the user to specify the path.
"
" - The <Leader>t binding invokes Command-T using a known path that
"   the user is expected to populate.
"
"   - This plugin looks for and uses the first directory or symlink
"     named 'cmdt_paths' under ~/.vim
"
"   - One approach is to create a directory of symlinks to all
"     projects, so that invoking Command-T creates a file list
"     of all your projects' files. In this manner, you wouldn't
"     need to use more than one path with Command-T; you just
"     always seed Command-T will *all* files, from all projects.
"
" USAGE: Populate the cmdt_paths directory with a bunch of symlinks
"        to your projects, and use <Leader>t to invoke Command-T on
"        this path.

" BROKN: The following <Leader>t shortcut to :CommandT is somewhat broken.
"
" - The author has since settled on using junegunn/fzf.vim:
"     https://github.com/junegunn/fzf.vim
"   Which is wired by DepoXy:
"     https://github.com/DepoXy/depoxy#🍯
"       ~/.depoxy/ambers/home/.vim/pack/DepoXy/start/vim-depoxy/plugin/fzf-config.vim
"   Whereas this script wires CtrlP and CommandT:
"     https://github.com/ctrlpvim/ctrlp.vim
"     https://github.com/wincent/command-t
"
" - All 3 projects are actively maintained.
"   - But they use different implementations:
"     - junegunn/fzf.vim    — uses Go
"     - ctrlpvim/ctrlp.vim  — uses Vimscript
"     - wincent/command-t   — legacy uses Ruby; latest uses Lua (Neovim-only)
"
" - The author assumes the Go implementation is the fastest, though I have
"   not profiled. However, junegunn/fzf.vim works well for me, and does
"   everything I need (which is just opening files; I don't use FZF for
"   opening buffers, jumping to tags, running commands, or traversing
"   history, etc., which are other features some of the plugins support).
" 
" DUNNO: Note that the following code wires CommandT to <Leader>t, but for
" some reason it's not showing all the projects I have symlinked under the
" cmdt_paths directory. Rather, it's showing just one directory's .git/
" files, for some reason (even though it indicates that it scans 100s of
" thousands of files). But I don't really care to investigate, because
" junegunn/fzf.vim works (and I have it's functionality wired to
" <Leader>F and a few other bindings).
" - SAVVY: Note if you disable the following code, the CommandT plugin
"   nonetheless wires itself to <Leader>t (and also wires <Leader>b
"   and <Leader>j), and you cannot disable these bindings (i.e., not
"   using a 'g:' global variable) unless you wanted to edit its source.
"   - CXREF:
"       ~/.vim/pack/wincent/start/command-t/plugin/command-t.vim
"     Or, if it's installed but disabled by default:
"       ~/.vim/pack/wincent/opt/command-t/plugin/command-t.vim

function! s:DubsFileFindrLocateCmdtPaths()
  if exists("g:dubs_file_finder_cmdt_paths")
    " Allow user to specify the project path.
    let l:ffdir = g:dubs_file_finder_cmdt_paths
  else
    " Check for known path first:
    "   ~/.vim/pack/landonb/start/dubs_file_finder/cmdt_paths
    let l:ffdir = $HOME . "/.vim/pack/landonb/start/dubs_file_finder/cmdt_paths"
  endif

  " Note isdirectory returns true (1) if symlink to directory.
  if ! isdirectory(l:ffdir)
    if exists("g:dubs_file_finder_cmdt_paths")
      echom 'Warning: g:dubs_file_finder_cmdt_paths is not a directory: '
        \ . g:dubs_file_finder_cmdt_paths
    endif

    " Find any cmdt_paths/ under ~/.vim.
    let l:ffdir = finddir("cmdt_paths", pathogen#split(&rtp)[0] . "/**")
    if l:ffdir != ''
      call s:DubsFileFindrWarnIfMultipleCmdtPathsPresent()

      let l:ffdir = fnamemodify(l:ffdir, ":p:h")
    else
      " No file, but there should be a template we can copy.
      let s:fftemplate = s:DubsFileFindrCreateCmdtPathsFromTemplate()
    endif
  endif

  return l:ffdir
endfunction

" Warn-Tell the user if they've got multiple file finder directories.
function! s:DubsFileFindrWarnIfMultipleCmdtPathsPresent()
  let l:matches = finddir("cmdt_paths", pathogen#split(&rtp)[0] . "/**", -1)

  if (len(l:matches) > 1)
    echom 'Warning: Found ' . dcnt . ' cmdt_paths/ matches under ~/.vim'
      \ . ' / Consider setting g:dubs_file_finder_cmdt_paths'
  endif
endfunction

function! s:DubsFileFindrCreateCmdtPathsFromTemplate()
  let l:tmplate = finddir('cmdt_paths.template', pathogen#split(&rtp)[0] . "/**")

  if l:tmplate == ''
    echomsg 'Warning: dubs_file_finder could not find cmdt_paths.template'

    return
  endif

  let l:tmplate = fnamemodify(l:tmplate, ":p")

  " Get the filename root, i.e., drop the ".template",
  " but first remove the trailing slash.
  let l:sepr = pathogen#slash()
  let l:ffdir = substitute(l:tmplate, l:sepr.'$', '', 'g')
  let l:ffdir = fnamemodify(l:ffdir, ":r")

  " Make a copy of the template.
  if has('macunix')
    " Default macOS BSD cp's -a same as -pPR, and -r and -R mutually exclusive.
    " - On linux (has('unix')?), GNU -a same as -dR.
    silent execute '!/bin/cp -a ' . l:tmplate . ' ' . l:ffdir
  else
    " Linux/GNU cp.
    silent execute '!/bin/cp -ra ' . l:tmplate . ' ' . l:ffdir
  endif

  return l:ffdir
endfunction

function! s:OpenCmdtPaths(ffdir)
  " While we could cache the cmdt_paths location, check it every time,
  " in case user/something changed g:dubs_file_finder_cmdt_paths.
  if a:ffdir != ''
    let l:ffdir = a:ffdir
  else
    let l:ffdir = s:DubsFileFindrLocateCmdtPaths()
  endif

  if 1 | echomsg 'dubs_file_finder: ffdir: ' . l:ffdir | endif

  if l:ffdir == ''
    " ALTLY: echomsg
    call confirm('Notice: To use <Leader>t, add symlinks to ' . s:fftemplate)

    return
  endif

  " See s:SetupCommandTPlainVim(), which uses Lua tooling.
  if has('nvim')
    " The wincent/command-t v6 Lua :CommandT does not accept path arg.
    lcd l:ffdir

    :CommandT
  else
    execute ':CommandT ' . l:ffdir
  endif
endfunction

function! s:SetupCommandTBinding()
  " User can call :DubsFileFinder with or without a path
  command -nargs=? -complete=dir DubsFileFinder
    \ call <SID>OpenCmdtPaths(<q-args>)

  " Or user can invoke <Leader>t
  if !hasmapto('<Plug>DubsFileFinder_OpenCmdtPaths')
    map <silent> <unique> <Leader>t
      \ <Plug>DubsFileFinder_OpenCmdtPaths
    " Map <Plug> to an <SID> function.
    noremap <silent> <unique> <script>
      \ <Plug>DubsFileFinder_OpenCmdtPaths
      \ :call <SID>OpenCmdtPaths('')<CR>
  endif
endfunction

call s:SetupCommandTBinding()

" -------------------------------------------------------------------

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" File Navigation/search using CtrlP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" CtrlP
" ^^^^^
"
" https://github.com/ctrlpvim/ctrlp.vim

" CtrlP is similar to Command-T. Most people just use one or the other.
" I've included both herein so you can get a taste of both, if you want.

" BUILD:
"
" - How to install CtrlP as a normal Vim plugin:
"
"   mkdir -p ~/.vim/pack/ctrlpvim/start
"   cd ~/.vim/pack/ctrlpvim/start
"   git clone https://github.com/ctrlpvim/ctrlp.vim.git
"
" - How to create help tags:
"
"   :Helptags ~/.vim/pack/ctrlpvim/opt/ctrlp.vim/doc
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
"
" CALSO:
"
"   While :CtrlP is wired, author uses junegunn/fzf.vim instead:
"
"     https://github.com/junegunn/fzf.vim
"
"   And wires it to <Leader>F and a few other bindings using a
"   DepoXy Vim plugin:
"
"     https://github.com/DepoXy/depoxy/blob/release/home/.vim/pack/DepoXy/start/vim-depoxy/plugin/fzf-config.vim
"
"   - Found within the DepoXy project:
"
"     https://github.com/DepoXy/depoxy#🍯
"
"   - Which you might have locally at:
"
"     ~/.depoxy/ambers/home/.vim/pack/DepoXy/start/vim-depoxy/plugin/fzf-config.vim
"
"   Note that CtrlP is written in 'pure Vimscript', whereas junegunn/fzf.vim
"   runs a Go command. So if your vendor doesn't let you run Go on your
"   work machine, you might want/need to use :CtrlP instead.
"
"   DUNNO: However, :CtrlP (like :CommandT, as discussed above) doesn't
"   quite work for the author — it only shows a few files.
"   - But rather than investigate, I'm deprecating this plugin in favor
"     of junegunn/fzf.vim and DepoXy's vim-depoxy plugin.

" Enable CtrlP.
" - SAVVY/2015-01-27: Other code expects first entry of &rtp to be ~/.vim,
"                     so use += to append and not ^= to prepend.
set runtimepath+=~/.vim/pack/ctrlpvim/opt/ctrlp.vim

function! s:SetCtrlPUserCommandRg()
  " SAVVY: Testing shows `rg` skip graphics formats: *.jpg, *.png, *.xcf
  " USYNC: Similar rg --glob's:
  "   ~/.depoxy/ambers/home/.projlns/infuse-projlns-core.sh
  "   ~/.kit/sh/home-fries/lib/alias/alias_rg_tag.sh
  "   ~/.vim/pack/landonb/start/dubs_file_finder/plugin/dubs_file_finder.vim
  "   ~/.vim/pack/landonb/start/dubs_grep_steady/bin/vim-grepprg-rg-sort
  let g:ctrlp_user_command = 'rg "" %s'
    \ . ' --hidden'
    \ . ' --follow'
    \ . ' --no-ignore-vcs'
    \ . ' --no-ignore-parent'
    \ . ' --files-with-matches'
    \ . ' --smart-case'
    \ . ' --color=never '
    \ . ' --glob !.git/'
    \ . ' --glob !.tox/'
    \ . ' --glob !node_modules/'
    \ . ' --glob !*.svg'
    \ . ' --glob !*.xpm'
endfunction

function! s:SetCtrlPUserCommandAg()
  " -l --files-with-matches Only print the names of files containing
  "                         matches, not the matching lines....
  " -g PATTERN              Print filenames matching PATTERN.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endfunction

function! s:SetCtrlPUserCommand()
  let g:ctrlp_follow_symlinks = 1
  let g:ctrlp_show_hidden = 1

  " Speed up fuzzy file finding -- and respect .ignore and .gitignore rules!
  if executable("rg")
    call s:SetCtrlPUserCommandRg()
  elseif executable("ag")
    call s:SetCtrlPUserCommandAg()
  " else, nothing special, probably falls back to grep or find.
  endif
endfunction

call s:SetCtrlPUserCommand()

