username = "varokas"
password = "$1$S8Ju2HIh$p9e50ZSxgtwn/8CTx3.kh/"
user_home = "/home/#{username}"
group = "sudo"
uploader_group = "uploader"
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

group "#{uploader_group}" do
  append true
  members "#{username}"
end

directory "#{user_home}/.ssh" do
  owner username
  group group
  action :create
  recursive true
end

cookbook_file "files/default/id_rsa" do
  owner username
  group group
  path "#{user_home}/.ssh/id_rsa"
  action :create
end

cookbook_file "files/default/id_rsa.pub" do
  owner username
  group group
  path "#{user_home}/.ssh/id_rsa.pub"
  action :create
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
  content "execute pathogen#infect()\nsyntax on\n"
  action :create
end

git "#{user_home}/.vim/bundle/nerdtree" do
  user username
  group group
  repository "https://github.com/scrooloose/nerdtree.git"
  reference "master"
end

#Proxy
template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 00644
  variables({
    :foresee_port => 3000,
    :teamcity_port => 8111
  })
  notifies :reload, "service[haproxy]"
end

#TeamCity
package "openjdk-7-jdk"

remote_file "#{user_home}/TeamCity-7.1.4.tar.gz" do
  source "http://download.jetbrains.com/teamcity/TeamCity-7.1.4.tar.gz"
  owner username
  group group
  action :create_if_missing
end

execute "tar" do
 user "root"
 group "root"
 command "tar zxf #{user_home}/TeamCity-7.1.4.tar.gz -C /var"
 action :run
 not_if do FileTest.directory?("/var/TeamCity") end
end

cookbook_file "files/default/teamcity" do
  owner "root"
  group "root"
  mode 755
  path "/etc/init.d/teamcity"
  action :create
end

execute "udate rc.d for teamcity" do
  command "update-rc.d teamcity defaults"
  user "root"
  group "root"
end

execute "start teamcity" do
  command "service teamcity start"
  user "root"
  group "root"
end

#NodeJs
apt_repository "nodejs" do
  uri "http://ppa.launchpad.net/chris-lea/node.js/ubuntu/" 
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C7917B12"
end
### TODO MAke this notifies only after successful apt-update
package "nodejs"

#Foresee
git "#{user_home}/foresee" do
  user username
  group uploader_group 
  repository "https://github.com/huskycode/foresee"
  reference "master"
end

execute "install_foresee" do
  command "npm install"
  cwd "#{user_home}/foresee"
  environment ({'HOME' => user_home}) 
  user username
  group uploader_group 
end

#global insatll should be done by root
execute "install_forever" do
  command "npm install forever -g"
  cwd "#{user_home}/foresee"
  environment ({'HOME' => user_home}) 
end

execute "stop_all_forever" do
  command "forever stopall"
  cwd "#{user_home}/foresee"
  environment ({'HOME' => user_home}) 
  user username
  group uploader_group 
end

execute "run_forever" do
  command "forever start app.js"
  cwd "#{user_home}/foresee"
  environment ({'HOME' => user_home}) 
  user username
  group uploader_group 
end
