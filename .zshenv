export PATH="$HOME/.pyenv/bin:$PATH"

fpath=(/usr/local/share/zsh/site-functions $fpath)

#AWSume alias to source the AWSume script
alias awsume=". awsume"
fpath=(~/.awsume/zsh-autocomplete/ $fpath)


eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

