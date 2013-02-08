#!/bin/bash
# or
#!/bin/ksh
##
## Labeled Tab-Separated Value parser / manipulator for shell
## Copyright (c) 2013 SATOH Fumiyasu @ OSS Technology Corp., Japan
##               <https://GitHub.com/fumiyas/>
##               <http://www.OSSTech.co.jp/>
##
## License: GNU General Public License version 3
##

LTSV_SEPARATOR="	"

ltsv_decode()
{
  typeset hash_name="${1-}"; shift || return 2
  typeset line
  if [[ -n "${1-}" ]]; then
    line="$1"; shift
  else
    read -r line || return 1
  fi

  ## Clear hash contents
  #eval "$hash_name=()"
  eval "$hash_name=([x]=dummy); unset $hash_name[x]"

  typeset setopt_orig="$-"
  typeset ifs_orig="$IFS"
  set -o noglob
  IFS="$LTSV_SEPARATOR"

  typeset kv k
  for kv in $line; do
    k="${kv%%:*}"
    ## Check if content is in "label:value" format
    [[ "$k" = "$kv" ]] && return 3
    ## Check if label is in "^[0-9A-Za-z_.-]+$/" pattern
    [[ "$k" = "${k##*[^0-9A-Za-z_.-]}" ]] || return 3
    eval "$hash_name"'[$k]="${kv#*:}"'
  done
  [[ "$-" = "$setopt_orig" ]] || set +o noglob
  IFS="$ifs_orig"

  return 0
}

ltsv_encode()
{
  typeset hash_name="$1"; shift
  typeset ltsv k

  eval 'for k in "${!'"$hash_name"'[@]}"; do
    ltsv="$ltsv$LTSV_SEPARATOR$k:${'"$hash_name"'[$k]}"
  done'

  printf '%s\n' "${ltsv#$LTSV_SEPARATOR}"
}

ltsv_test()
{
  typeset -A h

  ltsv_decode h "foo:Foo	bar:Bar	baz:*"
  echo "\$?=$?"
  hash_dump h
  ltsv_encode h
  echo
  unset h

  typeset -A h
  ltsv_decode h < <(echo "foo:Foo	bar:Bar	baz:*")
  echo "\$?=$?"
  hash_dump h
  ltsv_encode h
  echo
  unset h

  ## ksh or zsh
  echo set |read t
  if [[ -n "$t" ]]; then
    typeset -A h
    echo "foo:Foo	bar:Bar	baz:*" |ltsv_decode h
    echo "\$?=$?"
    hash_dump h
    ltsv_encode h
    echo
    unset h
  fi

  typeset -A h
  ltsv_decode h "BAD label-value	bar:Bar	baz:*"
  echo "\$?=$?"
  hash_dump h
  echo
  unset h

  typeset -A h
  ltsv_decode h "BAD label:Foo	bar:Bar	baz:*"
  echo "\$?=$?"
  hash_dump h
  echo
  unset h
}

hash_dump()
{
  typeset hash_name="$1"; shift
  typeset k v

  echo "$hash_name="
  eval 'for k in "${!'"$hash_name"'[@]}"; do
    echo "  $k: ${'"$hash_name"'[$k]}"
  done'
}

if [[ "${0##*/}" = "ltsv.sh" ]]; then
  ltsv_test
else
  return 0
fi

