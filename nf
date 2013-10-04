#!/bin/bash
# Normalizes file names.

if [[ $# == 0 ]] ; then
	echo >&2 "No files specified."
	exit 1
fi

rename_failed() {
	echo >&2 "Unable to rename a file."
	exit 1
}

do_rename() {
	file="$2"
	pattern="$1"

	old_name=$(basename "$file")
	new_name=$(sed "$pattern" <<< "$old_name")

	if [[ $old_name = $new_name ]] ; then
		echo "'$file' not renamed"
	else
		echo "$file -> $new_name"
		if ! $dry_run ; then
			mv -- "$file" $(dirname "$file")/"$new_name"
		fi
	fi
}

noargs=false
spaces_only=false
dry_run=false

for file ; do
	if ! $noargs ; then
		case "$file" in
			-s)
				spaces_only=true
				continue
				;;
			-n)
				dry_run=true
				continue
				;;
			--)
				noargs=true
				continue
				;;
		esac
	fi

	if [[ ! -e "$file" ]] ; then
		echo >&2 "'$file' does not exist"
		continue
	fi

	pattern='s/ /-/g'

	if ! $spaces_only ; then
		# Quoting is strange, but it makes each line consistent.
		# We add each part of the pattern individually to make parts of the patterne easy to comment out.
		pattern="$pattern;"'s/\(.*\)/\L\1/'
		pattern="$pattern;"'s/%20/-/g'
		pattern="$pattern;"'s/_/-/g'
		pattern="$pattern;""s/'//g"
		pattern="$pattern;"'s/"//g'
		pattern="$pattern;"'s/,//g'
		pattern="$pattern;"'s/&/-/g'
		pattern="$pattern;"'s/(//g'
		pattern="$pattern;"'s/)//g'
		pattern="$pattern;"'s/://g'
		pattern="$pattern;"'s/!//g'
		pattern="$pattern;"'s/\?//g'
		pattern="$pattern;"'s/\.-/-/g'

		# TODO: make this sane.
		for i in {0..5} ; do
			pattern="$pattern;"'s/--/-/g'
		done
	fi

	do_rename "$pattern" "$file"
done
