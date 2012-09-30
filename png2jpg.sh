#!/bin/zsh
# convert a png to a jpg
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2012-09-29

NAME="$0:t"

# inspired by
# http://brettterpstra.com/png-to-jpeg-and-how-i-loathe-imagemagick-options/
# because I, too, get confused by ImageMagick and convert, but often want to convert
# pngs to jpgs.

	# change if desired
BACKGROUND_COLOR=white

if ((! $+commands[convert] ))
then

	# note: if convert is a function or alias, it will come back not found

	echo "$NAME: convert (part of ImageMagick) is required but not found in $PATH"
	exit 1

fi

EXIT=0

for PNG in $@
do

	# convert filename to full path
	PNG=($PNG(:A))

		# make sure input actually exists
	if [[ -e "$PNG" ]]
	then

			# get the extension, in lowercase
		EXT=$PNG:e:l

			# make sure the extension is png (case insensitive)
		if [[ "$EXT" == "png" ]]
		then

				# the same filename as the PNG except with the extension changed the jpg
			JPG=$PNG:r.jpg

				# does the JPG version already exist?
			if [[ -e "$JPG" ]]
			then
				echo "$JPG already exists"
				EXIT=1
			else
					# if not, let's create it
				convert "$PNG" -background "$BACKGROUND_COLOR" -mosaic +matte "$JPG" && \
				echo "$NAME: Created $JPG"
			fi
		else
				# if the ext is not png tell the user
			echo "$NAME: $PNG's EXT is not png"
			EXIT=1
		fi
	else
			# if the file does not exist tell the user
		echo "$NAME: $PNG:A does not exist"
		EXIT=1
	fi

done

	# if we ran into any errors, this will exit = 1 otherwise exit = 0
exit $EXIT

#
#EOF
