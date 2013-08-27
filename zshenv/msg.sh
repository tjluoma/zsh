
msg () {

	if [ "$1" = "sticky" -o "$1" = "--sticky" ]
	then
			shift
			STICKY="yes"
			EXIT='0'
			[[ "$NAME" == "" ]] && NAME='[msg]'

	elif [ "$1" = "error" ]
	then
			shift
			STICKY="yes"
			((ERRORS++))
			EXIT='0'
			[[ "$NAME" == "" ]] && NAME='[msg]'

	elif [ "$1" = "die" -o "$1" = "--die" ]
	then
			shift
			STICKY='yes'
			EXIT='1'
			[[ "$NAME" == "" ]] && NAME='[die]'

	else
			# if NOT sticky and not die
			STICKY="no"
			EXIT='0'
			[[ "$NAME" == "" ]] && NAME='[msg]'
	fi


	if [[ "$#" == "0" ]]
	then
				# set MESSAGE to stdin
			MESSAGE=`cat -`
	else
				# set MESSAGE to arguments
			MESSAGE="`echo $@`"
	fi

		# if the LOGS variable isn't set…
	[[ "$LOGS" == "" ]] && LOGS="/tmp"

		# if `timestamp` isn't defined, use `date`
	timestamp () { date '+%F--%H.%M.%S' }

	DAY=$(strftime '%F' $EPOCHSECONDS || date '+%F')

		# send MESSAGE to stdout
		# 2013-06-26 disabled logging
	echo "${NAME}@${HOST}: ${MESSAGE} [Time: `timestamp`] " # | tee -a "$LOGS/msg.$DAY.txt"

	if (( $+commands[growlnotify] )) 	# if 'growlnotify' is in $PATH then
	then

# OLD code to launch Growl if needed
# 		ps auxwww | fgrep -v fgrep | fgrep -q '/Applications/Growl.app/Contents/MacOS/Growl' ||\
# 		(open -g -a Growl && \
# 			growlnotify \
# 				--identifier "msg" \
# 				--appIcon Growl \
# 				--message 'Growl Started' '[msg]') ||\
# 			die "Failed to launch Growl"

ps cx | egrep -q ' (Growl|GrowlHelperApp)$'

EXIT="$?"

if [ "$EXIT" = "1" ]
then
			# Random number between 10-20
		SLEEPFOR=$(echo $[${RANDOM}%11+10])

		# see if growl will be running if we wait a few
		sleep $SLEEPFOR

		ps cx | egrep -q ' (Growl|GrowlHelperApp)$'

		EXIT="$?"

		if [ "$EXIT" = "1" ]
		then

			OS_VER=$(sw_vers -productVersion)

			case "$OS_VER" in
				10.6*)
						if (( $+commands[growlctl] ))
						then

								# if growlctl is found, then start Growl and give it a few seconds to get settled in
							growlctl start
							sleep 5

						else
								# if growlctl is not found, yell, but continue. Who knows, maybe it'll work.

							echo "\n\n	[msg] ERROR: Growl does not appear to be running, this is Snow Leopard, but 'growlctl' is not found. You're on your own, mate.\n\n"

						fi
				;;

				*)
					# This will be the "all others" case, which, for me will be either 10.7 or 10.8
					# (or later) but could conceivably be 10.5 or earlier.


					open -a Growl

					EXIT="$?"

					if [ "$EXIT" != "0" ]
					then

							echo "\n\n	[msg] Tried to launch Growl (open -a Growl) but it failed.\n\n"
					fi


				;;

			esac

		fi
fi



		if [[ "$STICKY" == "yes" ]] 	# if sticky then
		then							# set growlnotify to sticky

				GN_STICKY='--sticky'
		else
				GN_STICKY=''
				GN_IMAGE=''
		fi

			# note that I can define "$GROWL_APP" in scripts to choose a different app icon
			# similarly I can use $GROWL_ID if I wan to specify a specific ID for the Growl alert
			# which is handy if you are using 'sticky' to keep an alert around for awhile and then
			# replace it with another message when a process completes.
		growlnotify \
			--appIcon "${GROWL_APP-Growl}" \
			$GN_STICKY \
			--identifier "${GROWL_ID-EPOCHSECONDS}" \
			--message "$MESSAGE" \
			"$NAME"
##
		if [ "$EXIT" = "1" ]
		then

			tput bel 2>/dev/null	# sound terminal beep

			exit 1
		fi
##

	fi # if growlnotify is installed
}

# alias die='msg die'			# this will cause the script, etc to immediately exit=1

function die {

		if [ "$#" = "1" ]
		then

			msg --die "$@"
			exit 1

		else

			EXITCODE="$1"

			shift

			msg --die "$@"
			exit $EXITCODE

		fi
}

alias suffer='msg error'	# this will let the script continue but EVENTUALLY exit=1



# @todo - check on zsh list for way to use SHLVL to use return vs exit

# END msg/sticky

#DBURL  =
