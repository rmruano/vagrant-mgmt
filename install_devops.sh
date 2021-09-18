#!/bin/bash


echo "----------------------------"
echo "I: Running devops bootstrap"
if [ ! -e /home/vagrant/provision/.devops_done ]; then

  # Create local work path ---------------------------------------
  sudo cp /vagrant/devops_sync/README.md /devops
  sudo mkdir /devops/local
  sudo chown vagrant:vagrant /devops/local
  sudo chown vagrant:vagrant /devops/README.md



  # Better ls --------------
  sudo apt-get install exa
  echo "# Better ls
  alias ll='exa -bghHlS'" >> ~/.bash_aliases



  # prompt customization -------------------------------------------
  # https://github.com/magicmonty/bash-git-prompt
#  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
#  echo "GIT_PROMPT_END_USER=\"\n\${BrightCyan}\$(whoami)@\$(hostname)\${ResetColor} \${BoldRed}➤  \${ResetColor}\"" >> ~/.bash-git-prompt/.git-prompt-colors.sh
#  echo "# Git prompt
#  if [ -f \"\$HOME/.bash-git-prompt/gitprompt.sh\" ]; then
#      GIT_PROMPT_ONLY_IN_REPO=1
#      source ~/.bash-git-prompt/gitprompt.sh
#  fi
#" >> ~/.bashrc

  # Powerline shell https://github.com/b-ryan/powerline-shell#bash
  # Remember to install the fonts on the host first: https://github.com/powerline/fonts  >>>  sudo apt-get install fonts-powerline
  echo "Remember to install the fonts on the host first >>>  sudo apt-get install fonts-powerline"
  sudo apt-get install -yq python3-pip
  pip install powerline-shell
  echo "# Powerline prompt
    function _update_ps1() {
        PS1=\$(~/.local/bin/powerline-shell \$?)
    }
    if [[ \$TERM != linux && ! \$PROMPT_COMMAND =~ _update_ps1 ]]; then
        PROMPT_COMMAND=\"_update_ps1; \$PROMPT_COMMAND\"
    fi
  " >> ~/.bashrc

  # change prompt color to cyan bg to avoid any misunderstanding
  sed -ri -e "s/01;32m/00;46m/g" ~/.bashrc



  # Install samba ---------------------------------------
#  sudo apt-get install -y samba
#  sudo echo "[Devops]
#comment = Devops local
#path = /devops/local
#browseable = yes
#read only = no
#writable = yes
#guest ok = no" >> /etc/samba/smb.conf
#  (echo vagrant; echo vagrant) | sudo smbpasswd -s -a vagrant
#  sudo service smbd restart



  # Install tools ---------------------------------------
    # mongodb cli
    wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
    sudo apt-get update
    sudo apt-get install -yq mongodb-mongosh



  # Run synced bootstrap if exists ---------------------------------------
    echo "I: Running /devops/sync/bootstrap.sh if exists"
    if [ -e /devops/sync/bootstrap.sh ]; then
      sudo chmod +x /devops/sync/bootstrap.sh;
      sudo -u vagrant /devops/sync/bootstrap.sh
      echo "I: completed running the /devops/sync/bootstrap.sh"
    fi


  touch /home/vagrant/provision/.devops_done
fi
echo "----------------------------"

exit 0