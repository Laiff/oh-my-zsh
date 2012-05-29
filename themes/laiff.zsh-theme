# Fino theme by Max Masnick (http://max.masnick.me)

# Use with a dark background and 256-color terminal!
# Meant for people with RVM and git. Tested only on OS X 10.7.

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    echo '○'
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

function battery_charge {
  if [[ $(acpi 2&>/dev/null | grep -c '^Battery.*Discharging') -gt 0 ]] ; then

    # Battery 0: Discharging, 94%, 03:46:34 remaining
    bat_status=`acpi | awk -F ':' {'print $2;'} | awk -F ',' {'print $1;'}`
    bat_percent=`acpi | awk -F ':' {'print $2;'} | awk -F ',' {'print $2;'} | sed -e "s/\s//" -e "s/%.*//"`
    bat_remain=`acpi | cut -f3 -d ',' | awk -F ' ' {'print $1;'}`

    if [ $bat_percent -lt 20 ]; then cl='%{$FG[202]%}'
    elif [ $bat_percent -lt 50 ]; then cl='%{$FG[226]%}'
    else cl='%{$FG[040]%}'
    fi

    if [ "$bat_status" = " Discharging" ]; then remain=" [$bat_remain]"
    else remain=''
    fi

    filled=${(l:`expr $bat_percent / 10`::▸:)}
    empty=${(l:`expr 10 - $bat_percent / 10`::▹:)}
    echo $cl$remain$filled$empty'%F{default}'
  else
	echo ''
  fi
}

local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'


PROMPT="%{$reset_color%}╭─%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}${git_info} %{$FG[239]%}using%{$FG[243]%} ${rvm_ruby} 
%{$reset_color%}╰─$(virtualenv_info)$(prompt_char) "

RPROMPT="%{$FG[239]%}[%*]%{$reset_color%} $(battery_charge)"

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"