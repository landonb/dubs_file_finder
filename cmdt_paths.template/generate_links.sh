#!/bin/bash

# This command makes links to important files and dirs in your home dir.

# Remove existing links, lest you add links to the linked directories.
find . -maxdepth 1 -type l -exec /bin/rm {} +

# for fname in ~/.bash*; do
#   /bin/ln -sf $fname dubs-$(basename $fname | cut -c 2-)
# done
/bin/ln -sf $HOME/.vim home-vim
/bin/ln -sf $HOME/.vimrc home-vimrc

# Add more links here. E.g., maybe you have somelike like
#  /bin/ln -sf /srv/client_1 work-client-1
#  /bin/ln -sf $HOME/src/client_2 work-client-2
#  etc.
# Find all your projects and add links for them here,
# and then run this script.

