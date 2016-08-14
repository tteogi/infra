#!/bin/bash
sudo mv /tmp/services/*.service /etc/systemd/system

sudo chmod +x -R /opt/bin
sudo chown root:root -R /opt/bin

sudo mkdir -p /opt/shell
sudo mv /tmp/shell/*.sh /opt/shell
sudo chmod +x -R /opt/shell
sudo chown root:root -R /opt/shell

#sudo rm -rf /tmp/services
sudo mkdir -p /opt/etc
sudo mkdir -p /opt/datas
sudo mkdir -p /opt/etc/consul.d
sudo mkdir -p /opt/etc/nomad.d

sudo chmod +x -R /opt/etc
sudo chown root:root -R /opt/etc
sudo chmod +x -R /opt/datas
sudo chown root:root -R /opt/datas