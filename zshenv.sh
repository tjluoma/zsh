# this file is intended to be linked as ~/.zshenv

zmodload zsh/datetime	# EPOCHSECONDS / strftime
zmodload zsh/stat		# zstat

setopt ALL_EXPORT

LC_ALL=C

	# GNU cp and mv
VERSION_CONTROL='numbered'

	# cpan stuff - http://craiccomputing.blogspot.com/2007/04/perl-cpan-on-mac-osx.html
FTP_PASSIVE=1

LOGS="$HOME/Library/Logs"

	# get the 'short' hostname
HOST=$(hostname -s)

	# make it lowercase
HOST="$HOST:l"

	# use it for 'unison'
UNISONLOCALHOSTNAME="$HOST"

if [ -d "${HOME}/Dropbox/github/$HOST/zsh/zshenv/" ]
then

		IFS=$'\n' find "${HOME}/Dropbox/github/air/zsh/zshenv" -iname \*.sh -print | while read line
		do

			source "$line"

		done
fi
