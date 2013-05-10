Labeled Tab-Separated Value parser / manipulator for shell
======================================================================

  * Copyright (c) 2013 SATOH Fumiyasu @ OSS Technology Corp., Japan
  * License: GNU General Public License version 3
  * URL: <https://GitHub.com/fumiyas/LTSV.sh>
  * Twitter: <https://twitter.com/satoh_fumiyasu>

What's this?
----------------------------------------------------------------------

See http://ltsv.org/ and the following example:

    #!/bin/bash
    # or
    #!/bin/ksh

    . ./LTSV.sh

    typeset -A hash
    ## Parse an LTSV in a string
    LTSV_decode hash "foo:Foo	bar:Bar	baz:*baz*"
    ## Parse an LTSV read from STDIN
    #LTSV_decode hash

    echo "${hash[foo]}"
    echo "${hash[bar]}"
    echo "${hash[baz]}"

    for key in "${!hash[@]}"; do
      echo "$key: ${hash[$key]}"
    done

    ## Manipulate an LTSV from a hash
    LTSV_encode hash

Requirements
----------------------------------------------------------------------

  * bash or ksh (ksh93)

TODO
----------------------------------------------------------------------

  * Add more test
  * Support zsh
  * `LTSV_encode`: Reject or escape TAB and CR character in values

