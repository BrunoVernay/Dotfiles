
# Dotfiles
Tracking some configuration files via GitHub

Using `vcsh` allows to use git in $HOME directory without having everything in git. You kind of "enter" the git world only when you want. 
(It can also put different files in different repositories. I could have use another repository for the `bin/` folder for example).


Notes:
- `vcsh _MyRepo_ write-ignore` will ignore all the untracked files (very handy)
- `vcsh _MyRepo_`  will "enter" into git world: you can issue git command directly. (`exit` to go back) 
- `git ls-files` list all tracked files
- To remove a file from the index: `git rm --cached ~/.oh-my-zsh/oh-my-zsh.sh`


Ref:
- https://github.com/RichiH/vcsh
- https://github.com/BrunoVernay/Dotfiles 
- https://dotfiles.github.io/

