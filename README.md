Based on https://www.atlassian.com/git/tutorials/dotfiles

First, follow the instructions for the Window Boxstart scripts
https://github.com/RobCannon/boxstarter

Then, enter this batch of commands from a WSL session

```
alias dtf='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
git clone --bare "https://github.com/RobCannon/dotfiles.git" $HOME/.cfg
dtf config --local status.showUntrackedFiles no
dtf checkout -f main
dtf push --set-upstream origin main


.local/bin/init-os.sh
.local/bin/init-repos

source ~/.bash_profile
```
