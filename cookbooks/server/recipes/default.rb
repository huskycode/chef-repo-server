username = "varokas2"
password = "$1$R8hQjBm4$lpvowSICZl5k/5VOxgnH10"
#####

package "curl"
package "wget"

package "finger"

package "screen"
package "openssh-server"

user username do
  gid "sudo"
  home "/home/#{username}"
  password password
end
 
