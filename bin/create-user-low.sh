
 
MYUSER="broum"
DATA=/srv/data
useradd --no-user-group --shell /bin/zsh -G disk,dialout,lock,audio $MYUSER
# sudo userdel -Zr broum

# Safer and easier  to give up priviledges:
# "su -" sets user environment.  "<<-" removes leading spaces. "\$i" otherwise it is expanded too early
su - $MYUSER <<- EOF
  cd
  rm -rf {Desktop,Documents,Music,Pictures,Videos}
  for i in {Documents,Music,Pictures,Videos,ISOs,dev}; do
    ln -s $DATA/\$i 
  done
  rm .zshrc
  vcsh clone https://github.com/BrunoVernay/Dotfiles.git
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.config/oh-my-zsh
  git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
EOF

echo "Do not forget to set a password !!!"
