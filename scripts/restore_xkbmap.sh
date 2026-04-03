#!/bin/bash
xkbcomp $DISPLAY /tmp/current.xkb
sed -i 's/ccedilla,        Ccedilla,        NoSymbol,        NoSymbol/ccedilla,        Ccedilla,        semicolon,        colon/' /tmp/current.xkb
xkbcomp /tmp/current.xkb $DISPLAY
