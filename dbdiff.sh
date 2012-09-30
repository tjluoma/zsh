#!/bin/zsh
# if no arguments given, check current working directory for Dropbox conflicted files. If given an argument (presumed to be a path to a Dropbox conflicted copy), look for the original file, and compare them running 'bbdiff' (part of BBEdit)
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2012-09-30

NAME="$0:t"

if ((! $+commands[bbdiff] ))
then

	# note: if bbdiff is a function or alias, it will come back not found

	echo "$NAME: bbdiff is required but not found in $PATH. If you want to use 'diff' change both instances of 'bbdiff --wait' to 'diff' in $0."
	exit 1

fi

# if no arguments, run on any conflicted copy files in CWD

if [ "$#" = "0" ]
then

	command ls -1 *conflicted\ copy* |\
	while read line
	do

		COPY="$line"

		ORIG=$(echo "$COPY" | sed 's# ([a-zA-Z0-9].*s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])##g')

		if [[ -e "$ORIG" ]]
		then
			echo "$NAME: comparing $ORIG to $COPY"
			bbdiff --wait "$ORIG" "$COPY"
		else
			echo "$ORIG not found ($COPY)"
		fi

	done

	exit
fi

# if an argument (or more than one) is given, assume that it is a Dropbox duplicate and look for an 'original' to compare it against.

for COPY in $@
do

	COPY=($COPY(:A))

	if [ -e "$COPY" ]
	then

		ORIG=$(echo "$COPY" | sed 's# ([a-zA-Z0-9].*s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])##g')

		if [[ -e "$ORIG" ]]
		then
			echo "$NAME: comparing $ORIG to $COPY"
			bbdiff --wait "$ORIG" "$COPY"
		else
			echo "$ORIG not found ($COPY)"
		fi

	fi

done


exit 0

#
#EOF
