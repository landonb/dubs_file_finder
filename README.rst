Dubsacks Vim — File Finder
==========================

**Or, Just a Command-T Wrapper**

About This Plugin
-----------------

This script wraps
`Command-T <https://github.com/wincent/Command-T>`__
so it's available from ``<Ctrl-D>`` and so you can
invoke Command-T without needing to supply any
directory paths.

Project page: https://github.com/landonb/dubs_file_finder

File Finder Commands
--------------------

The short of it:

1. Find the ``cmdt_paths`` directory in your Vim folder.
| It'll be under ``dubs_file_finder``.

2. Populate the directory with symlinks.

3. Press ``<Ctrl-D>``.

The long of it:

This script doesn't require you to enter a
target directory when invoking the file finder.
It'll search all the projects linked to from a
special folder.

- The plugin will automatically create the ``cmdt_paths``
  directory for you. Check under this
  project's directory, ``dubs_file_finder``.

In this manner, it's just one key-combo to invoke Command-T,
and you don't have to specify the directory to scan. You might
be concerned that listing all projects' files together will make
it harder to find the file you want, but Command-T is such a great
tool that even with thousands of source files, it's still a cinch to
find and open files.

You can instead access Command-T directly
using ``:CommandT {some_dir}``.

Compare to `CtrlP <https://github.com/kien/ctrlp.vim>`__
and `NERDTree <https://github.com/scrooloose/nerdtree>`__,
two other plugins that help you find files.

Key Mappings
------------

Finding and Opening Files (Trendy Methods)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``Ctrl-D``                   Calls Command-T to            Calls ``:CommandT dubs_file_finder/cmdt_paths`` so you can use a fuzzy autocomplete
                              Fuzzy-find by filename        algorithm to type part of a filename and open it.
                                                            The ``cmdt_paths`` directory is just a collection of symlinks
                                                            to project folders whose files you want Command-T to list for you.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``:CtrlP <somedir>``         Use CtrlP to find files       The `CtrlP <https://kien.github.io/ctrlp.vim/>`__
                                                            plugin is nifty, but I like Command-T better,
                                                            so I didn't bind this command to an easy key combination.
                                                            It's included anyway so you can try different find-and-open-file
                                                            techniques and decide which one you like best.
===========================  ============================  ==============================================================================

Finding and Opening Files (Other Methods)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In addition to using the methods described above to find and open
files or using the Project plugin, there are obviously other 
methods of finding and opening files, including:

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``:NERDTreeToggle``          Toggle NERD Tree tray         `The NERD Tree <https://github.com/scrooloose/nerdtree>`__
                                                            is similar to the Project tray, but it shows your whole filesystem
                                                            (so you don't have to prime it, e.g., edit ``.vimprojects``, to use it).
                                                            It's a nice plugin, but if you use the Command-T or the Project tray,
                                                            you probably won't ever use NERDTree.
                                                            Dubsacks includes this plugin.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``:Explore``                 Vim command similar           See ``:help explore``.
                              to NERD Tree
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``:tabedit``, etc.           Vim built-ins                 Vim has a lot of ways to open new or existing files,
                                                            and to specify whether to open them in the current
                                                            window, a new window, or a new tab.
                                                            See ``:help`` for such commands as
                                                            ``:edit``, ``:new``, ``:tabedit``, and ``:tabnew``.
                                                            See also the Wikia article,
                                                            `Open file under cursor <http://vim.wikia.com/wiki/Open_file_under_cursor>`__.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``$ gvim ...``               From the terminal             Use, e.g., ``$ gvim --servername ABC --remote-silent <filename>``
                                                            to open files in the same gVim instance
                                                            by specifying the ``servername`` switch.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 Quickfix window              Search and error output       You can search files using ``\g`` and double-click or <enter> on entries
                                                            in the quickfix window to open files.
                                                            Other commands that show log and error files can also be loaded into
                                                            the quickfix window so you can easily jump to specific lines of files.
===========================  ============================  ==============================================================================

