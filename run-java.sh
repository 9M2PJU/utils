#!/bin/bash
usage="usage: $(basename $0) <flags> [<class_name> [<function_definition>]]"

if (( $# == 0 )) ; then
	echo $usage
fi



if (( $# >= 2 )) ; then
	class_name=$2
fi
if (( $# >=3 )) ; then
	class_name=$3
fi

# Check for class names or function definitions
if (( $# >= 1 )) ; then
	# Specify class name to use or insert
	if [[ $1 == "-c" || $1 == "-i" ]] ; then
		class_name=$2

		# Class definition insertion
		if [[ $1 == "-i" ]] ; then
			insert_class_name=1
		fi

		if [[ $3 == "-m" ]] ; then
			# Specify main function insertion
			func_def="public static void main(String args[])"
			mode=$4
		elif [[ $3 == "-f" ]] ; then
			# Specify custom function definition to insert
			func_def=$4
			mode=$5
		else
			mode=$3
		fi
	else
		mode=$1
	fi
else
	# Class name must be specified for now
	echo "No class specified"
	exit 1
fi

code_file="/tmp/$class_name.java"
class_file="/tmp/$class_name.class"

# Clear out temporary file
rm $code_file 2> /dev/null
touch "$code_file"

# Add class and function specifiers
if [[ ! -z $insert_class_name ]] ; then
	echo "class $class_name"" {" >> "$code_file"
fi
if [[ ! -z $func_def ]] ; then
	echo "$func_def"" {" >> "$code_file"
fi

# Read each line from stdin and put it in the temp code
while read line
do
	if [[ $line == "q" ]] ; then
		break
	else
		echo $line >> "$code_file"
	fi
done

# Close the class and function specifiers
if [[ ! -z $insert_class_name ]] ; then
	echo "}" >> "$code_file"
fi
if [[ ! -z $func_def ]] ; then
	echo "}" >> "$code_file"
fi

# Compile, run, and cleanup
if [[ $mode == "r*" ]] ; then
	javac -d . "$code_file" && java "$class_file"
elif [[ $mode == "s*" ]] ; then
	less $code_file
fi
# Cleanup
rm "$class_file"
