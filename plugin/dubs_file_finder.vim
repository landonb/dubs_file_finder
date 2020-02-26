" File: dubs_file_finder.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project Page: https://github.com/landonb/dubs_file_finder
" Summary: Just a Command-T wrapper
" License: GPLv3
" -------------------------------------------------------------------
" Copyright © 2009, 2015-2018 Landon Bouma.
" 
" This file is part of Dubs Vim.
" 
" Dubs Vim is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation, either version
" 3 of the License, or (at your option) any later version.
" 
" Dubs Vim is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty
" of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
" the GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with Dubs Vim. If not, see <http://www.gnu.org/licenses/>
" or write Free Software Foundation, Inc., 51 Franklin Street,
"                     Fifth Floor, Boston, MA 02110-1301, USA.
" ===================================================================

" ------------------------------------------
" About:

" Command-T is a great tool for quickly finding and opening
" project files.
"
" This script wraps Command-T so it's available from <Ctrl-D>.
"
" This script doesn't require you to enter a target directory.
" Rather, you'll want to create a ``cmdt_paths`` directory
" somewhere in your Vim folder, and you'll want to populate
" the directory with symlinks to all of your projects.
"
" In this manner, it's just one key-combo to invoke Command-T,
" and you don't have to specify the directory to scan. You might
" be concerned that listing all projects' files together will make
" it harder to find the file you want, but Command-T is such a great
" tool that even with thousands of source files, it's still a cinch to
" find and open files.

if exists("g:plugin_dubs_file_finder") || &cp
  finish
endif
let g:plugin_dubs_file_finder = 1

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" File Searching Helpers
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Regarding :set path= and :find
" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

" Vim has a built-in :find command, but it doesn't implement
" partial or fuzzy finding like Command-T, and it's tedious
" to have to setup 'path' to list all your project directories.
"
" Regardless, here's roughly how it works.
"
" The default path includes the current directory, /usr/include, and
" a trailing comma which also indicates the current directory. E.g.,
"   path=.,/usr/include,,
" Add additional paths to the path for find to search. E.g.,
"   let &path = &path . "," . "/path/to/source/**"
"   ...
" Note that you have to use double-stars to include sub-directories,
" up to 30 levels deep.
" After setting up the path, you can use :find to open files...
" but it's just not as good as Command-T.
" See :h file-searching, :h find, :h args, :h argadd.

" Command-T
" ^^^^^^^^^^

" https://github.com/wincent/Command-T
"
"  mkdir -p ~/.vim/pack/wincent/start
"  cd ~/.vim/pack/wincent/start
"  git clone https://github.com/wincent/command-t.git
"
" Create help tags:
"
"  :Helptags
"
" Compile:
"
"  sudo apt-get install ruby-dev
"  cd ~/.vim/pack/wincent/start/command-t/ruby/command-t
"  ruby extconf.rb
"  make
"
" Usage:
"
"  :CommandT <some_dir>
"
" Help:
"
"  :h command-t

" NOTE: CommandT has some nifty options.
"        Check the docs for more options.
"         https://github.com/wincent/Command-T

" Walk up directory from file's base and look for .git, etc,
" when starting Command-T using the current file's location.
"  See: g:CommandTSCMDirectories ('.git,.hg,.svn,.bzr,_darcs')
let g:CommandTTraverseSCM = "file"

" Always include dot-files, otherwise they're only included if you dot.
let g:CommandTAlwaysShowDotFiles = 1

" 2017-02-25: Here's a new (to me) one:
"
"   Warning: maximum file limit reached
"
"   Increase it by setting a higher value in $MYVIMRC; eg:
"     let g:CommandTMaxFiles=200000
"   Or suppress this warning by setting:
"     let g:CommandTSuppressMaxFilesWarning=1
"   For best performance, consider using a fast scanner; see:
"     :help g:CommandTFileScanner
"let g:CommandTSuppressMaxFilesWarning=1
let g:CommandTMaxFiles=1000000
" 2017-12-12: We should try git, which runs `ls-files` and falls back to `find`.
" 2018-05-17: Took me long enough! "git" isn't working. Not quite sure why.
"   Well, it seems to work on some symlinks under cmdt_paths/, but not all.
"   Whatever. I don't care too much. Command-T takes a few seconds to load the
"   first time it's run, and I thought maybe git's ls-files would help it run
"   faster; and now I still don't know (well, the "git" option loads Command-T
"   a lot faster than the "find" option, but obviously it's not finding all the
"   same files).
"let g:CommandTFileScanner = "git"
let g:CommandTFileScanner = "find"

" CtrlP
" ^^^^^

" CtrlP is similar to Command-T. Most people just use one or the other.
" I've included both herein so you can get a taste of both, if you want.

" https://github.com/kien/ctrlp.vim
"
" Checkout the source as a git submodule:
"
"  mkdir -p ~/.vim/pack/kien/start
"  cd ~/.vim/pack/kien/start
"  git clone https://github.com/kien/ctrlp.vim.git
"
" Create help docs:
"
" :helptags ~/.vim/pack/kien/start/ctrlp.vim/doc
"
" Restart Vim.
"
" Usage:
" 
"  :CtrlP <some_dir>
"
" NOTE: CtrlP won't find the file from which the command was run,
"       so don't get trapped by searching for the file that's active.
"
" Help:
"
"  :help ctrlp.txt
"  :help ctrlp-options

" Enable CtrlP.
" 2015.01.27: Other code expects first entry of &rtp to be
"             ~/.vim, so use += to append and not ^= to prepend.
set runtimepath+=~/.vim/pack/kien/start/ctrlp.vim

" Some other options...
"  let g:ctrlp_working_path_mode = 'ra'
"  let g:ctrlp_root_markers

" Command-T Compared to (Vs!) CtrlP
" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

" First impressions: I like Command-T better.
"   1. It includes the active file when searching (otherwise
"      I just get confused!)
"      ([lb] notes this is probably easy to fix in the source,
"       but I don't want to bother finding out; I like Command-T.)
"   2. When first invoked, Command-T shows a big list of alphabatized
"      files (up to the top of your Gvim window) while CtrlP shows just
"      a handful of files and is already applying an algorithm to it
"      so the list looks incomplete.
"   3. The Command-T search algorithm feels more natural, at least
"      for the few things I searched. Even using a contiguous substring
"      of the filename I was looking for, CtrlP didn't always find my
"      file!
"   4. Command-T is compiled... and more processing intense, it seems,
"      but not too bad: it takes a few split seconds to start up on
"      large projects, but that's only the first time you run it after
"      starting Vim or searching a new project. I.e., on subsequent
"      searches, Command-T starts immediately. For this reason, in
"      addition to not wanting to have to change projects all the time,
"      I chose to create the cmdt_paths directory of symlinks.

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
    silent execute '!/bin/cp -ra ' . s:tmplate . ' ' . s:ffdir
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

