
if [ "$PATH" = "" ]
then
			export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/bin:$HOME/Dropbox/bin
fi

	# This is the file where I want my $PATH to be saved so I can easily use it in other scripts if,
	# for some reason, they aren't going to process ~/.zshenv
	# This way I know that all of my shells and shell scripts will get the same $PATH in the same order
f="$HOME/.path"

if [ -f "$f" -a -r "$f" ]
then
			# if $f exists as a readable file, then source it and return to the main .zshenv quickly
		source ${f} && return 0
else
		echo "\n\n\n	WARNING: no $f found. Creating one now. Pay attention.	\n\n\n"


		#export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/bin:$HOME/Dropbox/bin

			# if the $f file was not found then create it

			# get rid of the old PATH
		#unset PATH

			# here is a list of all of the folders that I might want in my $PATH
			# but ONLY if they exist.
			#
			# If they don't exist, don't put them in the $PATH
			#
			# Note that folders on top will be added to the FRONT of the path. If you want to ensure
			# that the system versions of commands are used, then put those at the top of this list

		for DIR in 	\
					${HOME}/Dropbox/bin \
					/usr/local/sbin \
					/usr/local/bin \
					/usr/bin \
					/usr/sbin \
					/sbin \
					/opt/X11/bin \
					/bin
		do

				# if the folder exists and is readable, add it to the $PATH
			[ -d "$DIR" -a -r "$DIR" ] && NEWPATH+="$DIR:"

		done

			# Now I want to use the $PATH that we have created
		rehash

			# now get rid of trailing : at the end of $PATH
		export NEWPATH=$(echo "${NEWPATH}" | sed 's#:$##g')

			# Now save the $PATH definition to the file
		echo "PATH=$NEWPATH" > "$f" || exit 1

		export PATH="$NEWPATH"

			# now tell the user what the PATH is
		echo "\n\n $funcstack[1]: Created $f. If it is not correct, or if you want to add to it later, you must edit that file directly. Here are the contents:\n\n"

		cat "$f"

fi


if (( $+commands[launchctl] ))
then

	# if the `launchctl` command is found, we are on a Mac, so let's see if the PATH is set properly for `launchd`

	LPATH=$(launchctl getenv PATH)

	if [ "$LPATH" != "$PATH" ]
	then

		launchctl setenv PATH "$PATH"

		echo "\n\n $funcstack[1]: NOTE: you should edit /etc/launchd.conf to make sure that the path is set properly there too."


		if (( $+commands[bbedit] ))
		then

			bbedit /etc/launchd.conf

		fi
	fi
fi

return 0
