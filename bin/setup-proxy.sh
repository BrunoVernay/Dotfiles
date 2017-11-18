#!/bin/bash

tee /etc/profile.d/proxymaybe.sh <<'EOF'
#!/bin/bash

if ping -q -c 2 -W 3 gad.schneider-electric.com > /dev/null 2>&1 ; then
    echo "Proxy ON"
#    export http_proxy="http://SESA147313@gateway.zscaler.net:80/"
#    export https_proxy=$http_proxy
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,.schneider-electric.com"

    export npm_config_proxy=$http_proxy
    export npm_config_https_proxy=$http_proxy

    # gsettings set org.gnome.system.proxy mode 'auto'
    #org.gnome.system.proxy autoconfig-url 'file:///etc/proxy.pac'
    gsettings set org.gnome.system.proxy use-same-proxy true
    gsettings set org.gnome.system.proxy mode 'manual'
    gsettings set org.gnome.system.proxy.http enabled false
    gsettings set org.gnome.system.proxy.http host 'gateway.zscaler.net'
    gsettings set org.gnome.system.proxy.http port 80
    gsettings set org.gnome.system.proxy.http use-authentication false
    gsettings set org.gnome.system.proxy.http authentication-password ''
    gsettings set org.gnome.system.proxy.http authentication-user 'SESA147313'
    gsettings set org.gnome.system.proxy.https host 'gateway.zscaler.net'
    gsettings set org.gnome.system.proxy.https port 443
    gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', '.schneider-electric.com']"
else
    echo "Proxy OFF"
    unset -v http_proxy https_proxy no_proxy npm_config_proxy npm_config_https_proxy
    gsettings set org.gnome.system.proxy mode 'none'
fi

EOF

mkdir -p /opt/bin

tee /opt/bin/proxymaybe.sh <<'EOF'
#!/bin/bash

if [[ $(curl -s -o /dev/null -I -w "%{http_code}" 74.125.133.115) != 301 ]]; then
 echo 'Set Proxy' > /opt/bin/proxy.txt
else
 echo 'Set NO Proxy' > /opt/bin/proxy.txt
fi
# if ping -q -c 2 -W 3 gad.schneider-electric.com > /dev/null 2>&1 ; then
EOF

chmod +x /opt/bin/proxymaybe.sh

tee /etc/systemd/system/proxy.service <<'EOF'
[Unit]
Description=My proxy service
After=network.target

[Service]
Type=oneshot
ExecStart=/opt/bin/proxymaybe.sh

[Install]
WantedBy=multi-user.target

EOF

# Might not be useful
tee /etc/proxy.pac <<'EOF'
  function FindProxyForURL(url,host) {

    var resolved_ip = dnsResolve(host);

    if (isInNet(resolved_ip, "192.168.1.0", "255.255.255.0")) {
       return "DIRECT";
    }
    return "PROXY 205.167.7.126:80; PROXY 165.225.76.40:80; DIRECT";
  }
EOF

