#!/bin/bash

if [[ ! -v OSCALDIR ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    source "$DIR/common-environment.sh"
fi

exitcode=0
shopt -s nullglob
shopt -s globstar
while IFS="" read -r p || [ -n "$p" ]
do
  if [ -n "$p" ]; then
    files_to_process="$OSCALDIR"/"$p"

    IFS= # disable word splitting    
    for file in $files_to_process
    do
      printf 'Validating: %s\n' "$file"
      xmllint --noout --schema "$OSCALDIR/build/metaschema/lib/metaschema.xsd" $file
      cmd_exitcode=$?
      if [ $cmd_exitcode -ne 0 ]; then
        printf 'XML schema validation failed for %s\n' "$file"
        exitcode=1
      fi
    done
  fi
done < $OSCALDIR/build/ci-cd/config/metaschema
shopt -u nullglob
shopt -u globstar

exit $exitcode
