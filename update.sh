#!/bin/sh

emacsclient -e '(org-babel-tangle-file "/home/ian/src/systemsetup/README.org")' && cp -a * /media/shared/ansible/
