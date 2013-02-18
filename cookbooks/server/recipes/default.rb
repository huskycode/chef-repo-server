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
  content "execute pathogen#infect()\nsyntax on\n"
  action :create
end

git "#{user_home}/.vim/bundle/nerdtree" do
  user username
  group group
  repository "https://github.com/scrooloose/nerdtree.git"
  reference "master"
end

#Deployments
remote_file "Jenkins" do
  path "#{node["jetty"]["webapp_dir"]}/jenkins.war"
  source "http://mirrors.jenkins-ci.org/war/latest/jenkins.war"
  owner node["jetty"]["user"] 
  group node["jetty"]["group"] 
  action :create_if_missing
end

directory "/home/jetty" do
  owner node["jetty"]["user"]
  group node["jetty"]["group"]
  action :create
  recursive true
end

service "jetty" do
  action :reload
end

#Huskycode
huskycode_root = "/var/www/huskycode"

template "#{node['nginx']['dir']}/sites-available/huskycode" do
  source "huskycode-site.erb"
  owner "root"
  group "root"
  mode 00644
  variables({
      :port => 81,
      :root => "#{huskycode_root}"
  })
  notifies :reload, 'service[nginx]'
end

nginx_site 'huskycode' do
  enable true 
end

# DO UFW Here !!

