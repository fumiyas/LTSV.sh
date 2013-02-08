Labeled Tab-Separated Value parser / manipulator for shell
======================================================================

  * Copyright (c) 2013 SATOH Fumiyasu @ OSS Technology Corp., Japan
  * License: GNU General Public License version 3
  * URL: <https://GitHub.com/fumiyas/ltsv.sh>
  * Twitter: <https://twitter.com/satoh_fumiyasu>

What's this?
----------------------------------------------------------------------

    #!/bin/bash
    # or
    #!/bin/ksh

    . ./ltsv.sh

    typeset -A hash
    ## Parse an LTSV in a string
    ltsv_decode hash "foo:Foo	bar:Bar	baz:*baz*"
    ## Parse an LTSV read from STDIN
    #ltsv_decode hash

    echo "${hash[foo]}"
    echo "${hash[bar]}"
    echo "${hash[baz]}"

    for key in "${!hash[@]}"; do
      echo "$key: ${hash[$key]}"
    done

    ## Manipulate an LTSV from a hash
    ltsv_encode hash

Requirements:
----------------------------------------------------------------------

  * bash or ksh (ksh93)

TODO
----------------------------------------------------------------------

  * Add more test
  * Support zsh
  * `ltsv_encode`: Reject or escape TAB and CR character in values

See also
----------------------------------------------------------------------

  * http://ltsv.org/

