#!/bin/bash

outfile=${1:-version.tex}

CHAPTERS=$(basename -s .tex $(ls *.tex|grep -Ev 'snlp-notes|version'))

commit=$(git log -n 1 --pretty=format:'%h' --abbrev-commit)
date=$(git log -n 1 --pretty=format:'%cd' --date=short)
modified=$(git status --porcelain --untracked-files=no|wc -l)
modifiedate=$date
[[ $modified -ne 0 ]] && commit="${commit}+";modifydate=$(date +%Y-%m-%d)
cat <<-END  > ${outfile}
	\pgfkeys{
	  /snlpnotes/version/.cd,
	  none/commit=$commit,
	  none/commitdate=$date,
	  none/modifydate=$date,
END

for ch in $CHAPTERS;do
    file=$ch.tex
    commit=$(git log -n 1 --pretty=format:'%h' --abbrev-commit $file)
    date=$(git log -n 1 --pretty=format:'%cd' --date=short $file)
    modified=$(git status --porcelain --untracked-files=no|grep $file|wc -l)
    modifydate=$date
    [[ $modified -ne 0 ]] \
        && read commit modifydate <<< "${commit}+ $(stat -c '%.10y' $file)"
    [[ -z $commit ]] && \
        read commit modifydate <<< "none $(stat -c '%.10y' $file)"
    echo "  $ch/commit/.initial=$commit," >> $outfile
    echo "  $ch/commitdate/.initial=$date," >> $outfile
    echo "  $ch/modifydate/.initial=$modifydate," >> $outfile
done
echo "}" >> $outfile
