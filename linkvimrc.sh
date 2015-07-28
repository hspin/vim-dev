#!/bin/bash

DIR=`pwd`
rm -f $HOME/.vimrc

ln -s $DIR/vimrc-2 $HOME/.vimrc-local

echo "link 2 is complete."
