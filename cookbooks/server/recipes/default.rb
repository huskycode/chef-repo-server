username = "varokas2"
password = "$1$R8hQjBm4$lpvowSICZl5k/5VOxgnH10"
user_home = "/home/#{username}"
group = "sudo"
#####

package "curl"
package "wget"
package "finger"
package "screen"
package "openssh-server"
package "git"

# User 
user username do
  gid group
  shell "/bin/bash"
  home user_home 
  password password
  supports :manage_home => true
end

# Vim
package "vim"

directory "#{user_home}/.vim/autoload" do
  owner username
  group group
  action :create
  recursive true
end 

directory "#{user_home}/.vim/bundle" do
  owner username
  group group
  action :create
  recursive true
end 

remote_file "#{user_home}/.vim/autoload/pathogen.vim" do
  source "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
  owner username
  group group
end

file "#{user_home}/.vimrc" do
  owner username
  group group
  content "execute pathogen#infect()\nsyntax on\nfiletype plugin indent on\n"
  action :create
end

git "#{user_home}/.vim/bundle/nerdtree" do
  user username
  group group
  repository "https://github.com/scrooloose/nerdtree.git"
  reference "master"
end

# Servers 
