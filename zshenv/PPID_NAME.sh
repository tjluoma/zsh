
SSH=no
LAUNCHD=no

PPID_NAME=$(command ps -o 'command=' -cp ${PPID} 2>/dev/null )

case "${PPID_NAME}" in
	sshd)
			SSH=yes
	;;

	launchd)
			LAUNCHD=yes
	;;

esac
