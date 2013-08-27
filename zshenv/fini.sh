
LAST="$?"


fini () {

	NAME="$NAME: [$funcstack:$t]"

	if [ "$LAST" = "0" -a "$ERRORS" -lt "1" -a "$EXIT" -lt "1" ]
	then
			exit 0

	elif [ "$LAST" != "0" ]
	then
			msg sticky "LAST is $LAST"

			exit $LAST

			exit 1

	elif [ "$ERRORS" -ge "1" ]
	then
			if [ "$ERRORS" = "1" ]
			then
					msg sticky "exiting with 1 error."
					exit 1
			else
					msg sticky "exiting with $ERRORS errors."
					exit 1
			fi

	elif [ "$EXIT" -ge "1" ]
	then

			if [ "$EXIT" = "1" ]
			then
					msg sticky "EXIT=1"
					exit 1
			else
					msg "exiting with $ERRORS errors."
					exit 1
			fi

	else

			msg sticky "$NAME: I'm not sure how we got here but this wasn't supposed to happen"

			exit

	fi

}
