
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.cargo/bin:$PATH"
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

ZSH_THEME="agnoster"

plugins=(
 git
 zsh-syntax-highlighting
 zsh-autosuggestions
 zsh-completions
 kube-ps1
)PS1='%n %1~ %#'

source $ZSH/oh-my-zsh.sh

prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n"
  fi
}

prompt_kubectx() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment '000' black "$(kube_ps1)${:gs/%/%%}"
  fi
}


prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path

   if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment "058" white
    else
      prompt_segment "028" $CURRENT_FG
    fi

    local ahead behind
    ahead=$(git log --oneline @{upstream}.. 2>/dev/null)
    behind=$(git log --oneline ..@{upstream} 2>/dev/null)
    if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21c5'
    elif [[ -n "$ahead" ]]; then
      PL_BRANCH_CHAR=$'\u21b1'
    elif [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21b0'
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_dir() {
  prompt_segment '235' white '%~'
}
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  #prompt_context
  prompt_kubectx
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '




KUBE_PS1_SYMBOL_ENABLE=true
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=''
KUBE_PS1_BG_COLOR=''
KUBE_PS1_NS_COLOR=white
KUBE_PS1_CTX_COLOR=white
KUBE_PS1_SYMBOL_COLOR=white
source /opt/homebrew/share/kube-ps1.sh
source /opt/homebrew/etc/bash_completion.d/az
source /opt/homebrew/etc/bash_completion.d/kubens
source /opt/homebrew/etc/bash_completion.d/kubectx

autoload bashcompinit && bashcompinit
autoload -U compinit && compinit

export DOCKER_BUILDKIT=1

alias k='kubectl'
alias kgp='k get pod'
alias kgs='k get service'
alias kgsec='k get secret'
alias kgi='k get ingress'
alias kl='k logs'
alias kc=kubectx
alias kn=kubens
alias knd='kn default'
alias knf='kn feature-branch'
alias kexec='kubectl exec -it'
alias kge='kubectl get events --sort-by=.metadata.creationTimestamp'

alias grbm='git rebase master'
alias grh1='git reset --hard HEAD~1'
alias grbmain='git rebase main'
alias gcmain='git checkout main'
gcamp() {
  gcam "$1" || echo already committed
  ggp
}
alias gcheat="open -a firefox https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh"
alias gpt="open -a chatgpt"
alias azpr='az repos pr create --open'
alias az-pr-id='az repos pr list --source-branch $(git rev-parse --abbrev-ref HEAD) | jq ".[0].codeReviewId"'
alias azprshow='az repos pr show --id $(az-pr-id)'
alias az-update-pr='az repos pr update --id $(az-pr-id)'
alias killchrome='pkill -a Chromium'


alias rider='open -a "Rider.app"'
alias pycharm='open -a "Pycharm.app"'
alias py='pycharm .'

alias goland='open -a "GoLand.app"'
alias rconf='code ~/.zshrc'
alias z="cd .."
alias zhome="cd ~"
alias zproj="cd ~/projects"
alias ghpr="gh pr create --fill && gh pr view --web"
alias zcp="cd ~/projects/"

alias azbunkerx="az login --tenant 75f3cac1-42b5-405f-9118-85bc506c621c"
alias kdebug="kubectl run -i --tty --rm debug --image=nicolaka/netshoot --restart=Never -- sh"
alias kevicdel='kubectl get pods --all-namespaces --field-selector=status.phase=Failed | grep Evicted | awk "{print \$2}" | xargs kubectl delete pod'

eval "$(/opt/homebrew/bin/brew shellenv)"
alias confsync='(cd ~/bootstrap-mac || git clone https://github.com/nicolaj-hartmann/bootstrap-mac.git ~/bootstrap-mac) && cd ~/bootstrap-mac && git pull && ansible-playbook setup.yml'

