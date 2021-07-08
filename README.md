Based on https://www.atlassian.com/git/tutorials/dotfiles

```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare  https://github.com/Equifax/robcannon-dotfiles.git $HOME/.cfg
config config --local status.showUntrackedFiles no
config checkout -f rob

sudo usermod -aG docker $USER
newgrp docker

source ~/.bash_profile
```

And, to get repos
```
gh auth login
init-repos
```
