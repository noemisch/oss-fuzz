#!/bin/bash

_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}

_main() {
	sudo -u postgres /etc/init.d/postgresql start
	sudo -u postgres psql -c "CREATE USER test WITH PASSWORD 'test' CREATEDB"
	sudo -u postgres psql -c "CREATE DATABASE test OWNER test"
	exec "$@"
}

if ! _is_sourced; then
	_main "$@"
fi