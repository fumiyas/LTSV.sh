#!/bin/bash
# or
#!/bin/ksh
##
## Labeled Tab-Separated Value parser / manipulator for shell
## Copyright (c) 2013-2015 SATOH Fumiyasu @ OSS Technology Corp., Japan
##               <https://GitHub.com/fumiyas/>
##               <http://www.OSSTech.co.jp/>
##
## License: GNU General Public License version 3
##

LTSV_SEPARATOR="	"

function LTSV_is_valid_name {
  typeset name="${1-}"; shift || return 1

  ## Invalid if null, has non alphanumeric char, start with non word char
  [[ $name = @(|*[^a-zA-Z0-9_]*|[^a-zA-Z_]*) ]] && return 1

  return 0
}

function LTSV_decode {
  typeset dict_name="${1-}"; shift || return 2
  LTSV_is_valid_name "$dict_name" || return 2

  typeset line
  if [[ -n "${1-}" ]]; then
    line="$1"; shift
  else
    read -r line || return 1
  fi

  ## Clear dict contents
  #eval "$dict_name=()"
  eval "$dict_name=([x]=dummy); unset $dict_name[x]"

  typeset setopt_orig="$-"
  typeset ifs_orig="$IFS"
  set -o noglob
  IFS="$LTSV_SEPARATOR"

  typeset res=0
  typeset kv k
  for kv in $line; do
    k="${kv%%:*}"
    ## Check if content is in "label:value" format
    [[ "$k" = "$kv" ]] && { res=3; break; }
    ## Check if label is in "^[0-9A-Za-z_.-]+$/" pattern
    [[ "$k" = "${k##*[^0-9A-Za-z_.-]}" ]] || { res=3; break; }
    eval "$dict_name"'[$k]="${kv#*:}"'
  done
  [[ "$-" = "$setopt_orig" ]] || set +o noglob
  IFS="$ifs_orig"

  return "$res"
}

function LTSV_encode {
  typeset dict_name="${1-}"; shift || return 2
  LTSV_is_valid_name "$dict_name" || return 2

  typeset ltsv k
  eval 'for k in "${!'"$dict_name"'[@]}"; do
    ltsv="$ltsv$LTSV_SEPARATOR$k:${'"$dict_name"'[$k]}"
  done'

  printf '%s\n' "${ltsv#$LTSV_SEPARATOR}"
}

function LTSV_test {
  typeset -A h

  LTSV_decode h "foo:Foo	bar:Bar	baz:*"
  echo "\$?=$?"
  LTSV_dict_dump h
  LTSV_encode h
  echo
  unset h

  typeset -A h
  LTSV_decode h < <(echo "foo:Foo	bar:Bar	baz:*")
  echo "\$?=$?"
  LTSV_dict_dump h
  LTSV_encode h
  echo
  unset h

  ## ksh or zsh
  echo set |read t
  if [[ -n "$t" ]]; then
    typeset -A h
    echo "foo:Foo	bar:Bar	baz:*" |LTSV_decode h
    echo "\$?=$?"
    LTSV_dict_dump h
    LTSV_encode h
    echo
    unset h
  fi

  typeset -A h
  LTSV_decode h "BAD label-value	bar:Bar	baz:*"
  echo "\$?=$?"
  LTSV_dict_dump h
  echo
  unset h

  typeset -A h
  LTSV_decode h "BAD label:Foo	bar:Bar	baz:*"
  echo "\$?=$?"
  LTSV_dict_dump h
  echo
  unset h
}

function LTSV_dict_dump {
  typeset dict_name="$1"; shift
  typeset k v

  echo "$dict_name="
  eval 'for k in "${!'"$dict_name"'[@]}"; do
    echo "  $k: ${'"$dict_name"'[$k]}"
  done'
}

if [[ "${0##*/}" = "LTSV.sh" ]]; then
  LTSV_test
else
  return 0
fi

