# Shell options
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend

# Completion with sudo
complete -cf sudo

# 
# Shell aliases
# 

# Confirm before overwriting
alias cp="cp -i"

# ls defaut config
alias ls='ls --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto -F' # ls par default (dossier en 1er + mise en forme de l'heure)
alias la='ls -a'
alias l='ls -l'
alias ll='l -a'

#
alias df='df -h'
alias free='free -m'
alias dus='du --max-depth=1 | sort -n'
alias cls='clear'
alias scr='screen -rdR'
alias dns='nslookup'
alias whois='whois -H'

# Use htop instead of top (if possible)
if type -P htop >/dev/null; then
  alias top='htop'
fi

#
# Colors
#
txtblk="\[\e[0;30m\]" # Black
txtred="\[\e[0;31m\]" # Red
txtgrn="\[\e[0;32m\]" # Green
txtylw="\[\e[0;33m\]" # Yellow
txtblu="\[\e[0;34m\]" # Blue
txtpur="\[\e[0;35m\]" # Purple
txtcyn="\[\e[0;36m\]" # Cyan
txtwht="\[\e[0;37m\]" # White
bldblk="\[\e[1;30m\]" # Black - Bold
bldred="\[\e[1;31m\]" # Red
bldgrn="\[\e[1;32m\]" # Green
bldylw="\[\e[1;33m\]" # Yellow
bldblu="\[\e[1;34m\]" # Blue
bldpur="\[\e[1;35m\]" # Purple
bldcyn="\[\e[1;36m\]" # Cyan
bldwht="\[\e[1;37m\]" # White
unkblk="\[\e[4;30m\]" # Black - Underline
undred="\[\e[4;31m\]" # Red
undgrn="\[\e[4;32m\]" # Green
undylw="\[\e[4;33m\]" # Yellow
undblu="\[\e[4;34m\]" # Blue
undpur="\[\e[4;35m\]" # Purple
undcyn="\[\e[4;36m\]" # Cyan
undwht="\[\e[4;37m\]" # White
bakblk="\[\e[40m\]"   # Black - Background
bakred="\[\e[41m\]"   # Red
badgrn="\[\e[42m\]"   # Green
bakylw="\[\e[43m\]"   # Yellow
bakblu="\[\e[44m\]"   # Blue
bakpur="\[\e[45m\]"   # Purple
bakcyn="\[\e[46m\]"   # Cyan
bakwht="\[\e[47m\]"   # White
txtrst="\[\e[0m\]"    # Text Reset

txtblue="\[\e[01;34m\]" # Bleu prompt
txtorange="\[\e[02;33m\]" # Orange prompt
txtgreen="\[\e[01;32m\]" # Vert fluo prompt
txtyellow="\[\e[01;33m\]" # Jaune prompt
txtlightblue="\[\033[1;36m\]" # Bleu clair prompt
txtteal="\[\e[02;36m\]" # turquoise, heure prompt
txtgray="\[\e[30;1m\]" # gris prompt


# Vim
export EDITOR=vim
export VISUAL=vim
if type -P vim >/dev/null; then
  alias vi=vim
fi


# prompt

function truncate_pwd {
 if [ "$HOME" == "$PWD" ]
 then
   newPWD="~"
 elif [ $HOME ==  ${PWD:0:${#HOME}} ]
 then
   newPWD="~${PWD:${#HOME}}"
 else
   newPWD=$PWD
 fi

  local pwdmaxlen=15
  if [ ${#newPWD} -gt $pwdmaxlen ]
  then
    local pwdoffset=$(( ${#newPWD} - $pwdmaxlen  ))
    newPWD=".+${newPWD:$pwdoffset:$pwdmaxlen}"
  fi
}

PROMPT_COMMAND=truncate_pwd
ROOT_UID=0

export PS1="${txtrst}${txtgray}[\t] ${txtblue}\u${txtrst}@${txtyellow}\h${txtrst}: ${txtjaunj}\w${txtrst}\$ "
export PS2="        -> "


#
# Functions
# 
myip () {
  wget -q -O - checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//';
}
mktar () { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz () { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz () { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjvf $1   ;;
      *.tar.gz)    tar xzvf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xvf $1    ;;
      *.tbz2)      tar xjvf $1   ;;
      *.tgz)       tar xzvf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo -e "${bldred}'$1' can't be extracted width extract()" ;;
    esac
  else
    echo -e "\n${bldred}'$1' is not a valid file"
  fi
}

switch-encoding () {
  if [ -f "$1" ] ; then
    case "`file -bi "$1"`" in
      *iso-8859-1)   iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$1" > "$1".utf-8 && echo -e "\n${bldgrn}New file : "$1".utf-8"  ;;
      *utf-8)   iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$1" > "$1".iso-8859-1 && echo -e "\n${bldgrn}New file : "$1".iso-8859-1" ;;
      *us-ascii)   echo -e "\n${bldylw}US-ASCII don't need to be changed"   ;;
      *)           echo -e "\n${bldred}'$1' encoding can't be switched: changeEncoding(`file -bi "$1"`)" ;;
    esac
  else
    echo -e "\n${bldred}'$1' is not a valid file"
  fi
}

if [ -f "$HOME/hosting/cli-prefs/git-shortcuts.sh" ]; then
  . "$HOME/hosting/cli-prefs/git-shortcuts.sh"
fi

export PAGER=less

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode

export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[01;33m'       # begin standout-mode - info box

export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;36m' # begin underline

#see http://superuser.com/questions/436314/how-can-i-get-bash-to-perform-tab-completion-for-my-aliases
function alias_completion {
    local namespace="alias_completion"

    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0

    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

        # skip aliases to pipes, boolan control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words=($alias_args)" 2>/dev/null || continue

        # skip alias if there is no completion function triggered by the aliased command
        [[ " ${completions[*]} " =~ " $alias_cmd " ]] || continue
        local new_completion="$(complete -p "$alias_cmd")"

        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi

        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    source "$tmp_file" && rm -f "$tmp_file"
};

alias_completion
