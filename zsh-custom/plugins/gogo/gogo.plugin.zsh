# Find repositories in $GOPATH/src. If an argument is provided, only
# repositories containing that argument string will be displayed. Otherwise,
# all repositories will be displayed.
#
# A repository is a directory under $GOPATH/src containing a .git subdirectory.
# If multiple repositories match, they are only displayed. If exactly one
# repository matches, we'll change directory into it.
#
# Example:
#
#   % gogo kops
#   % gogo ripta/ssp
#
gogo() {
  name="$1"
  choice="$2"
  basedir="$GOPATH/src"
  found=""
  matches=0
  for dir in $(find "$basedir" -maxdepth 4 -type d -name .git | sed "s#^$basedir/##" | sed 's#/.git$##')
  do
    if [ -n "$name" ]
    then
      if [[ "$dir" =~ "$name" ]]
      then
        if [[ ( $choice -eq 0 && $matches -eq 0 ) || $(($matches + 1)) -eq $choice ]]
        then
          found="$dir"
        fi
        matches=$(($matches + 1))
        echo "$dir"
      fi
    else
      matches=$(($matches + 1))
      echo "$dir"
    fi
  done
  if [[ $matches -eq 1 && $choice -le $matches ]]
  then
    cd "$basedir/$found"
  else
    if [[ $matches -gt 0 && $choice -gt 0 && $choice -le $matches ]]
    then
      cd "$basedir/$found"
      echo "» chose candidate #$choice «" >&2
    else
      echo "» found $matches candidates «" >&2
    fi
  fi
}

gowd() {
  cd $GOPATH/src/${1:-github.com/ripta}
}
