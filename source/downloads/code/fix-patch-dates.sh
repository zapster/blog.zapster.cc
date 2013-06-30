#! /bin/bash

set -e
set -u

FILES_WITHOUT_DATE=$(grep --exclude=series --exclude=.* -L "^# Date" $(hg locate))

for file in $FILES_WITHOUT_DATE ; do
    # hg revset limit() did not work so head is used in place
    DATE=$(hg log -r "sort(all(),date)" --template "{date|hgdate}\n" $file | head -n1)
    sed -i.orig "2a\\# Date $DATE" $file
done
