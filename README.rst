##############################
Dubs Vim |em_dash| File Finder
##############################

.. |em_dash| unicode:: 0x2014 .. em dash

**Or, Just a Command-T Wrapper**

About This Plugin
=================

This script wraps
`Command-T <https://github.com/wincent/Command-T>`__
so it's available from ``<Leader>t`` and so you can
invoke Command-T without needing to supply any
directory paths.

Installation
============

Installation is easy using the packages feature (see ``:help packages``).

To install the package so that it will automatically load on Vim startup,
use a ``start`` directory, e.g.,

.. code-block:: bash

    mkdir -p ~/.vim/pack/landonb/start
    cd ~/.vim/pack/landonb/start

If you want to test the package first, make it optional instead
(see ``:help pack-add``):

.. code-block:: bash

    mkdir -p ~/.vim/pack/landonb/opt
    cd ~/.vim/pack/landonb/opt

Clone the project to the desired path:

.. code-block:: bash

    git clone https://github.com/landonb/dubs_file_finder.git

If you installed to the optional path, tell Vim to load the package:

.. code-block:: vim

   :packadd! dubs_file_finder

Just once, tell Vim to build the online help:

.. code-block:: vim

   :Helptags

Then whenever you want to reference the help from Vim, run:

.. code-block:: vim

   :help dubs-file-finder

Install Command-T
-----------------

After installing the Command-T plugin, you'll have to build it.

.. code-block:: bash

   mkdir -p ~/.vim/pack/wincent/start
   cd ~/.vim/pack/wincent/start
   git clone https://github.com/wincent/command-t.git

   cd ~/.vim/pack/wincent/start/command-t/ruby/command-t
   sudo apt-get install -y ruby-dev
   ruby extconf.rb
   make

File Finder Commands
====================

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
============

Finding and Opening Files (Trendy Methods)
------------------------------------------

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
-----------------------------------------

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
                                                            Dubs Vim includes this plugin.
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

