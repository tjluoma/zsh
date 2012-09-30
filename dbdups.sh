#!/bin/zsh
# find all Dropbox duplicate/conflicted files
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2012-09-30

	# if you moved your Dropbox somewhere else, change this
DIR="$HOME/Dropbox"

	# I sort the output just because it puts them in a nicer order
find "$DIR" -path "*(*'s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])*" -print

	# NOTE: someone will probably suggest this:
	#
	# 	mdfind -onlyin "$DIR" filename:'conflicted copy'
	#
	# which sounds good, but gives false positives unless you add fgrep
	#
	#	mdfind -onlyin "$DIR" filename:'conflicted copy' | fgrep 'conflicted copy'

exit 0

#
#EOF
