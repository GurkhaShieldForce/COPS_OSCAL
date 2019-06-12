#!/bin/bash

if [[ -z "$OSCALDIR" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    source "$DIR/common-environment.sh"
fi

source $OSCALDIR/build/ci-cd/saxon-init.sh

if [ -z "$1" ]; then
  working_dir="$OSCALDIR"
else
  working_dir="$1"
fi
echo "${P_INFO}Working in '${P_END}${working_dir}${P_INFO}'.${P_END}"

exitcode=0
shopt -s nullglob
shopt -s globstar
while IFS="|" read path format model converttoformats || [[ -n "$path" ]]; do
  shopt -s extglob
  [[ "$path" =~ ^[[:space:]]*# ]] && continue
  # remove leading space
  path="${path##+([[:space:]])}"
  # remove trailing space
  converttoformats="${converttoformats%%+([[:space:]])}"
  shopt -u extglob

  if [[ ! -z "$path" ]]; then
    files_to_process="$OSCALDIR"/"$path"
    IFS= # disable word splitting    
    for file in $files_to_process
    do
      dest="$working_dir/${file/$OSCALDIR\/src\//}"
      dest_dir=${dest%/*} # remove filename
      echo "${P_INFO}Copying '$file' to '$dest'.${P_END}"
      mkdir -p "$dest_dir"
      cp "$file" "$dest"

      IFS=","
      for altformat in "$converttoformats"; do
        newpath="${file/$OSCALDIR\/src\//}" # strip off src
        newpath="${newpath/\/$format\///$altformat/}" # change path from old to new format dir
        newpath="${newpath%.*}" # strip extension

        dest="$working_dir/${newpath}-min.${altformat}"
        converter="$working_dir/$altformat/convert/oscal_${model}_${format}-to-${altformat}-converter.xsl"

        echo "${P_INFO}Generating ${altformat^^} file '$dest' from '$file' using converter '$converter'.${P_END}"
        xsl_transform "$converter" "$file" "$dest"
        cmd_exitcode=$?
        if [ $cmd_exitcode -ne 0 ]; then
          echo "${P_ERROR}Content conversion to ${altformat^^} failed for '$file'.${P_END}"
          exitcode=1
        fi
        # TODO: validate generated file

        case $altformat in
        json)
          # produce pretty JSON
          dest_pretty="$working_dir/${newpath}.${altformat}"
          jsome -r -c false -s 2 "$dest" > "$dest_pretty"

          # produce yaml
          newpath="${newpath/\/json\///yaml/}" # change path 
          dest_pretty="$working_dir/${newpath}.yaml"
          dest_pretty_dir=${dest_pretty%/*} # remove filename
          mkdir -p "$dest_pretty_dir"
          prettyjson --nocolor=1 --indent=2 --inline-arrays=1 "$dest" > "$dest_pretty"
          ;;
        esac

      done
    done
  fi
done < "$OSCALDIR/build/ci-cd/config/content"
shopt -u nullglob
shopt -u globstar

exit $exitcode
