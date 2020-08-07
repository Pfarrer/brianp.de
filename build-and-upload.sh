#!/bin/bash

hugo --enableGitInfo --minify

read -p 'FTP Host: ' HOST
read -p 'FTP User: ' USER
read -sp 'FTP Password: ' PASS

TARGETFOLDER='/brianp/'
SOURCEFOLDER='public/'

lftp -f "
set ftp:ssl-allow no
open ftp://$HOST
user $USER $PASS
mirror --only-newer --parallel=10 --reverse --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"