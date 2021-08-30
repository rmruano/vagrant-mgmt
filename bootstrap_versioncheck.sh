#!/bin/bash

echo ""
echo ""
echo ""

echo "----------------------------"
echo "I: Checking installed software & versions"
echo "----------------------------"


echo ""
echo ""
echo "**  GIT version >>> `git --version`"
echo "**  GIT config >>> `ls -la /home/vagrant | grep .gitconfig`"
echo "**  GIT credentials >>> `ls -la /home/vagrant | grep .git-credentials`"


echo ""
echo ""
echo "**  AWS-CLI version >>> `aws --version`"
echo "**  AWS-CLI configuration:"
aws configure list


echo ""
echo ""
echo "**  Docker running containers:"
sudo docker ps


echo ""
echo ""
echo "**  Terraform version:"
terraform -version
echo "**  Terraform credentials >>> `ls -la /home/vagrant/.terraform.d | grep credentials`"


echo ""
echo ""
echo "**  Node version >>> `node --version`"
echo "**  Npm version >>> `npm --version`"
echo "**  Nvm version >>> `nvm --version`"

echo ""
echo ""

echo "Theia IDE is available at: http://localhost:8000"

exit 0