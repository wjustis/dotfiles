#/bin/bash

HAVE_COMMON=true
HAVE_GCC=true
HAVE_GIT=true
HAVE_GOPRO=true
HAVE_PACMAN=true
HAVE_SCREEN=false
HAVE_TMUX=true
HAVE_VIM=true
HAVE_XSET=true

################################################################################
# SECTION: COMMON
################################################################################
if $HAVE_COMMON; then

alias ..='cd ..'
alias ....='cd ....'
alias ......='cd ......'
alias ........='cd ........'
function cdp { cd -P $1; }

alias disp='export DISPLAY=:0'

alias l='ls -lh'
alias la='ls -alh'

function mkdirc { mkdir -p "$1"; cd "$1"; }

alias x='exit'

fi
################################################################################
# SECTION: GCC
################################################################################
if $HAVE_GCC; then

function c {
	if test -f Makefile; then
		echo "you should probably be running make ..."
		exit 1;
	fi

  if [ -z "$CTARGET" ]; then CTARGET=run; fi
  if [ -z "$CEXT" ]; then CEXT=cpp; fi
  if [ -z "$CC" ]; then CC=g++; fi

	source_list=()
	while read f; do source_list+=("$f"); done < <(find ./ -name "*.$CEXT")

  echo " * CTARGET = $CTARGET"
  echo " *    CEXT = $CEXT"
  echo " *      CC = $CC"
  echo " *  CFLAGS = $CFLAGS"
  echo -n " *   FILES ="
  for f in "${source_list[@]}"; do echo -n " $f"; done
	echo -e "\n\033[1;90m# \033[0;93mcompiling \"$target\" ...\033[0m"

	status=$(g++ ${source_list[*]} -o $target $CFLAGS 2>&1)
	res="$?"
	if [ -n "$status" ]; then
		echo -e "\n\033[0;91m$status\033[0m\n";
		return 1
	fi
	if [ "$res" = "0" ]; then
		echo -e "\033[1;90m# \033[0;92mrunning \"$target\" ...\033[0m"
		echo -en "\033[1;90m"
		for x in $(seq 1 `tput cols`); do echo -n "="; done
		echo -e "\033[0m"
		./$target $ARGS
		echo -en "\033[1;90m"
		for x in $(seq 1 `tput cols`); do echo -n "="; done
		echo -e "\033[0m"
	fi
	return 0
}

fi
################################################################################
# SECTION: GIT
################################################################################
if $HAVE_GIT; then

alias git-log="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

fi
################################################################################
# SECTION: GIT
################################################################################
if $HAVE_GOPRO; then

gopro-timelapse () {
  read -p "Framerate (25): " framerate
  if [ -z "$framerate" ]; then framerate=25; fi
  fileregex=""
  while :; do
    read -ep "File regex: " fileregex
    if [ -n "$fileregex" ]; then break; fi
  done
  read -p "Start num (0): " startnum
  if [ -z "$startnum" ]; then startnum="0"; fi
  while :; do
    read -ep "Output path: " output
    if [ -n "$output" ]; then break; fi
  done
  echo "   framerate: $framerate"
  echo "  file regex: $fileregex"
  echo "   start num: $startnum"
  echo "   output to: $output"
  read -p "Ready? [Y/n]: " resp
  rlow="${resp,,}"
  if [ "$rlow" = "n" ] || [ "$rlow" = "no" ]; then return 1; fi
  ffmpeg -r $framerate -start_number $startnum -i "$fileregex" "$output"
}

gopro-concat () {
  dir=`pwd`
  of=/tmp/gopro-concat
  if [ -e "$of" ]; then rm "$of"; fi
  while :; do
    read -ep "Output path: " output
    if [ -n "$output" ]; then break; fi
  done
  ls -1 | egrep --color=never -i "*.mp4" | while read f; do
    echo "file '$dir/$f'" >> $of
  done
  cat "$of"
  read -p "Ready? [Y/n]: " resp
  rlow="${resp,,}"
  if [ "$rlow" = "n" ] || [ "$rlow" = "no" ]; then return 1; fi
  ffmpeg -f concat -i "$of" -c copy "$output"
}

gopro-frames () {
  while :; do
    read -ep "Input file: " input
    if [ -n "$input" ]; then break; fi
  done
  read -p "FPS (1): " fps
  if [ -z "$fps" ]; then fps="1"; fi
  while :; do
    read -ep "Output (regex): " output
    if [ -n "$output" ]; then break; fi
  done
  ffmpeg -i "$input" -filter:v fps=fps=$fps $output
}

fi
################################################################################
# SECTION: PACMAN
################################################################################
if $HAVE_PACMAN; then

alias pac="sudo pacman"

fi
################################################################################
# SECTION: SCREEN
################################################################################
if $HAVE_SCREEN; then

alias scr='screen -r'

fi
################################################################################
# SECTION: TMUX
################################################################################
if $HAVE_TMUX; then

function tn {
  n="$1"
  if [ -n "$n" ]; then
    tmux new -s "$n"
  else
    tmux new
  fi
}

function ta {
  n="$1"
  if [ -n "$n" ]; then
    tmux a -n "$n"
  else
    tmux a
  fi
}

alias tl="tmux ls"
  
fi
################################################################################
# SECTION: VIM
################################################################################
if $HAVE_VIM; then

function vimconf {
  sub=$1
  if [ -z "$sub" ]; then sub="default"; fi
  f="/home/will/.vimrc$sub"
  if [ ! -e "$f" ]; then
    echo -e "\033[0;91mConf does not exist: $f\033[0m"
    return 1
  fi
  ln -fs $f /home/will/.vimrc
  return 0
}

fi
################################################################################
# SECTION: XSET
################################################################################
if $HAVE_XSET; then

alias sson="xset s on; xset +dpms"
alias soff="xset dpms force suspend"
alias ssoff="xset s off; xset -dpms"
  
fi
