OS=$(sw_vers -productName 2>/dev/null || uname -s || echo 'OS_IS_UNKNOWN')

case "$OS" in
	'Mac OS X')
				# export PATH="${HOME}/Dropbox/Apps/site44/bin.luo.ma:${HOME}/Dropbox/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
				MAC=yes
	;;
esac
