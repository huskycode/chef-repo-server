chef-repo-server
===

A Chef repo to run with chef-solo to setup Huskycode server

* Tested only with Ubuntu 12.10 (x64)
* Works with Linode

Setup From Blank Ubuntu
---
Make sure curl and wget is installed

    sudo apt-get install curl wget

Install latest chef from ops code

    curl -L https://www.opscode.com/chef/install.sh | sudo bash

Clone this repository (make sure to use --recursive to clone the submodules)
    
    git clone --recursive <address> 

Or, we can force update it by this command
    
    git submodule update --init

Configure
--- 

Update the username, password. You can generate password by using this command

    openssl passwd -1 "<your password>"

Put in your pub/private key pair in 

    cookbooks/server/files/default/id_rsa
    cookbooks/server/files/default/id_rsa.pub

