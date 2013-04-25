override["jetty"]["java_options"] = "-Xmx384m -Djava.awt.headless=true -DJENKINS_HOME=/home/jetty/"
override['nginx']['default_site_enabled'] = false
override['firewall']['rules'] = [
  {"http" => { "port" => "80" } },
  {"https" => { "port" => "443" } },
  {"teamcity" => { "port" => "8111" } },
  {"ssh" => { "port" => "22" } },
  {"foresee" => { "port" => "3000" } },
  {"foresee_qa" => { "port" => "3000" } }
]
