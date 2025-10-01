# brackets

function git_status_count {
	echo "$1" |  cut -c -2 | grep $2 2>/dev/null | wc -l | sed "s/ //g"
}

function git_status_text {
	OUTPUT=$(git branch --show-current 2>/dev/null)
	if [ ! -z "$OUTPUT" ]; then
    # OUTPUT="git"
		STATUS=$(git status --short)
		MOD=$(git_status_count $STATUS "M") && (( MOD > 0 )) && OUTPUT=$OUTPUT" M$MOD"
		ADD=$(git_status_count $STATUS "A") && (( ADD > 0 )) && OUTPUT=$OUTPUT" A$ADD"
		DEL=$(git_status_count $STATUS "D") && (( DEL > 0 )) && OUTPUT=$OUTPUT" D$DEL"
		NST=$(git_status_count $STATUS "?") && (( NST > 0 )) && OUTPUT=$OUTPUT" U$NST"
		[ ! -z "$STATUS" ] && DIRTY="red" || DIRTY="yellow"
		echo -n " %{$fg[green]%}[ %{$fg[$DIRTY]%}\ue0a0 $OUTPUT %{$fg[green]%}]"
	fi
}

PROMPT=$'%{$fg[blue]%}%~$(git_status_text)
%{$fg[red]%}$%{$reset_color%} '

