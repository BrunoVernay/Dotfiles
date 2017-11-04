

DATA="/srv/data"

#rm -rf $DATA

mkdir -p $DATA
cd $DATA
umask 002
mkdir -p {Documents,Music,Pictures,Videos,Downloads,iso,dev}
chgrp -R users $DATA/*

#for i in {Documents,Music,Pictures,Videos,Downloads,iso,dev}; do
 #   mkdir -p $i
 #   umask 002
#done
 
MYUSER="bruno2"
useradd --no-user-group --shell /bin/zsh -G adm,disk,wheel,mail,dialout,lock,audio,vboxusers,libvirt,wireshark $MYUSER
# sudo userdel -Zr bruno2

# Safer and easier  to give up priviledges:
# "su -" sets user environment.  "<<-" removes leading spaces. "\$i" otherwise it is expanded too early
su - $MYUSER <<- EOF
  cd
  rm -rf {Documents,Music,Pictures,Videos,Downloads,iso,dev}
  for i in {Documents,Music,Pictures,Videos,Downloads,iso,dev}; do
    ln -s $DATA/\$i 
  done
EOF

