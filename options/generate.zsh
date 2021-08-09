#!/bin/zsh

zmodload zsh/mathfunc
setopt local_options BASH_REMATCH

MULTIPLIER=0.5

if [[ $# = 1 ]]; then
	MULTIPLIER=$1
fi

ceil() {
	echo "a=$1; b=1; if ( a%b ) a/b+1 else a/b" | bc
}

if [[ -f vegetation/10-asobo_species.xml ]]; then
	rm vegetation/10-asobo_species.xml
fi

ORIG_FILE=`cat ../../Official/Steam/fs-base/vegetation/10-asobo_species.xml`
NEW_FILE=''
I=0
while IFS='' read -r LINE || [ -n "${LINE}" ]; do
	(( I = $I + 1 ))
	if [[ $LINE =~ '\s*<Size min="([0-9\.]+)" max="([0-9\.]+)"/>' ]]; then
		(( min = ${BASH_REMATCH[2]} * $MULTIPLIER ))
		(( max = ${BASH_REMATCH[3]} * $MULTIPLIER ))
		min=`ceil $min`
		integer min=$((rint($min)))
		max=`ceil $max`
		integer max=$((rint($max)))
		NEW_LINE=`echo $LINE | sed  -nE "s/<Size min=\"([0-9\.]+)\" max=\"([0-9\.]+)\"\/>/<Size min=\"$min\" max=\"$max\"\/>/p"`
		echo $NEW_LINE >> vegetation/10-asobo_species.xml
		unset min max
	else
		echo $LINE >> vegetation/10-asobo_species.xml
	fi
done < ../../Official/Steam/fs-base/vegetation/10-asobo_species.xml
