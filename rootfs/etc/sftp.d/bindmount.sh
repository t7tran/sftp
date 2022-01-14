#!/usr/bin/env bash
# File mounted as: /etc/sftp.d/bindmount.sh
# Just an example (make your own)

[[ -d /opt/shared ]] || exit 0

function bindmount() {
	if [[ ! -e "$2" ]]; then
		if [ -d "$1" ]; then
			mkdir -p "$2"
		else
			touch "$2"
		fi
	fi
    mount --bind $3 "$1" "$2"
}

# Remember permissions, you may have to fix them:
# chown -R :users /data/common

for f in `find "/opt/shared" -maxdepth 1 -mindepth 1`; do
	if [[ -d "$f" ]]; then
		chmod 777 "$f" &>/dev/null
	elif [[ -f "$f" ]]; then
		chmod 666 "$f" &>/dev/null
	fi
	for home in `find "/home" -maxdepth 1 -mindepth 1 -type d`; do
		bindmount $f $home/`basename $f`
	done
done
