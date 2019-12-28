#!/bin/bash

# if run as root, uses sudo to change to "app" user

#set -eo pipefail
set -o pipefail
shopt -s nullglob

DEFAULT_COMMAND=/bin/bash

if [ -n "$DEBUG_ENTRYPOINT" ] ; then
	D=`date +'%F %T'` ; echo "${D} BEGIN docker-entrypoint-su.sh"
fi

# if command starts with an option, prepend default
if [ "${1:0:1}" = '-' ]; then
	set -- $DEFAULT_COMMAND "$@"
fi

# skip setup if help/version is requested
wantHelp=
for arg; do
	case "$arg" in
		-'?'|--help|-V|--version)
			wantHelp=1
			break
			;;
	esac
done

# skip this extra work if just displaying help
if [ -z "$wantHelp" ] ; then
	for F in /usr/local/entrypoint.d/*.sh ; do
		if [ -n "$DEBUG_ENTRYPOINT" ] ; then
			D=`date +'%F %T'` ; echo "${D} RUNNING ${F}"
		fi
		. $F
		if [ -n "$DEBUG_ENTRYPOINT" ] ; then
			D=`date +'%F %T'` ; echo "${D} COMPLETED ${F}"
		fi
	done
fi

if [ -n "$DEBUG_ENTRYPOINT" ] ; then
	D=`date +'%F %T'` ; echo "${D} DONE docker-entrypoint-su.sh"
fi

if [ "$(id -u)" = '0' ] ; then
  #exec su app "$@"
  exec sudo -u app "$@"
else
  exec "$@"
fi

if [ -n "$DEBUG_ENTRYPOINT" ] ; then
	D=`date +'%F %T'` ; echo "${D} AFTER EXEC docker-entrypoint-su.sh"
fi
