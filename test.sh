#!/bin/bash
# or
#!/bin/ksh

. ./LTSV.sh

typeset -A hash
LTSV_decode hash "foo:Foo	bar:Bar	baz:*baz*"

echo "${hash[foo]}"
echo "${hash[bar]}"
echo "${hash[baz]}"

for key in "${!hash[@]}"; do
  echo "$key: ${hash[$key]}"
done

LTSV_encode hash

