#!/usr/bin/env bash

set -euo pipefail

touch /boot/ssh

cat <<EOF > /etc/NetworkManager/system-connections/wifi.nmconnection
[connection]
id=wifi
uuid=965bc859-14c7-4e6f-bffe-65f09cd631b9
type=wifi
interface-name=wlan0
[wifi]
mode=infrastructure
ssid=${wifi_ssid}
[wifi-security]
auth-alg=open
key-mgmt=wpa-psk
psk=${wifi_pass}
[ipv4]
method=auto
[ipv6]
addr-gen-mode=default
method=auto
[proxy]
EOF
chmod 600 /etc/NetworkManager/system-connections/wifi.nmconnection

cat <<EOF > /etc/ssh/sshd_config.d/custom.conf
PermitRootLogin without-password
PasswordAuthentication no
PubkeyAuthentication yes
AllowUsers root
AuthorizedKeysFile /etc/ssh/authorized_keys
EOF

cat <<EOF > /etc/ssh/authorized_keys
${ssh_pubkey}
EOF

cat <<EOF > /etc/hostname
jezdzik
EOF

cat <<EOF > /etc/hosts
127.0.0.1 localhost jezdzik
::1 localhost jezdzik
EOF

cat <<EOF > /etc/nftables.conf
table ip nat {
    chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;
        tcp dport 80 redirect to :8080
    }
}
EOF

cat <<EOF > /etc/systemd/system/jezdzik.service
[Unit]
Description=jezdzik

[Service]
Type=simple
ExecStart=/jezdzik
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

systemctl enable nftables jezdzik 2>&1

systemctl disable triggerhappy userconfig dphys-swapfile 2>&1
