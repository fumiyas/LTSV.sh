#!/bin/bash
# or
#!/bin/ksh

. ./ltsv.sh

typeset -A hash
ltsv_decode hash "foo:Foo	bar:Bar	baz:*baz*"

echo "${hash[foo]}"
echo "${hash[bar]}"
echo "${hash[baz]}"

for key in "${!hash[@]}"; do
  echo "$key: ${hash[$key]}"
done

ltsv_encode hash

