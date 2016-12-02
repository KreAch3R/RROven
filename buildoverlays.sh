#!/bin/bash

# Copyright (C) 2016 KreAch3R

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

# You may obtain a copy of the License at
#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build overlay apks using the terminal

#Variables, EDIT THESE
sdkdir=~/bin/android/sdk
androidver=25
toolsver=$androidver.0.0

#DON'T EDIT THESE
aapt=$sdkdir/build-tools/$toolsver/aapt
androidjar=$sdkdir/platforms/android-$androidver/android.jar
currentdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#DON'T EDIT THESE

#Color output
red=`tput setaf 1`
green=`tput setaf 2`
orange=`tput setaf 3`
blue=`tput setaf 4`
cyan=`tput setaf 6`
reset=`tput sgr0`

# Functions

function aaptbuild() {
	for app in $apps; do
			name=$(basename $app)
			#Build package
			echo ${green}"Running aapt: "${reset}$name.apk
			$aapt package -v -f -M $app/AndroidManifest.xml -S $app/res/ -I $androidjar -F $app/$name.apk &> /dev/null # NOT hiding output (for now)
	done
}

function signapk() {
	for app in $apps; do
			name=$(basename $app)
			#Sign package
			echo ${green}"Sign: "${reset}$name.apk
			java -jar $currentdir/sign.jar $app/$name.apk --override
	done
}

function notify() {
	echo ${cyan}"Build COMPLETE ${reset}"
}

# Start of the script

# Build only the specific one, or everything in the same directory
if [[ $# -ne 0 ]] ; then
    apps="$@"
else
    apps=$(find $currentdir/* -maxdepth 0 -type d)
fi

aaptbuild
signapk
notify
