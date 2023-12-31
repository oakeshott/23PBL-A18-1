cat <<EOF | sudo tee /etc/bcc-installer.sh
#/bin/bash
export LLVM_ROOT=/usr/lib/llvm-12/
cd /usr/src
sudo git clone https://github.com/iovisor/bcc.git -b v0.25.0
sudo mkdir -p /usr/src/bcc/build
cd /usr/src/bcc/build
sudo cmake ..
# sudo cmake .. -DCMAKE_PREFIX_PATH=/usr/lib/llvm-12
sudo make -j8
sudo make install
sudo cmake -DPYTHON_CMD=python3 ..
pushd src/python/
sudo make -j8
sudo make install
popd
EOF

cat <<EOF | sudo tee /etc/pyenv-installer.sh
#!/usr/bin/env bash
git clone https://github.com/pyenv/pyenv ~/.pyenv
echo 'export PYENV_ROOT="\${HOME}/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="\$PYENV_ROOT/bin:\$PATH"' >> ~/.bashrc
echo 'eval "\$(pyenv init -)"' >> ~/.bashrc
echo 'export PYTHONPATH=\${PYTHONPATH}:/home/ubuntu/.pyenv/versions/3.9.15/lib/python3.9/site-packages:/usr/lib/python3/dist-packages/' >> ~/.bashrc
EOF
cat <<EOF | sudo tee /etc/bootstrap.sh
#!/usr/bin/env bash
echo *************************
echo ****  Finish Setup   ****
echo *************************
sudo timedatectl set-timezone Asia/Tokyo
echo *************************
echo *      Apt install      *
echo *************************
TZ=Asia/Tokyo
ln -snf /usr/share/zoneinfo/ /etc/localtime && echo \${TZ} > /etc/timezone
DEBIAN_FRONTEND=noninteractive
sudo apt update -y
# sudo apt install linux-image-5.15.0-78-generic linux-headers-5.15.0-78-generic linux-modules-extra-5.15.0-78-generic
sudo apt install -y wget openssh-server golang iperf3 jq netperf arping sysstat tmux hping3
sudo apt install -y bison build-essential flex git libedit-dev libllvm12 llvm-12-dev libclang-12-dev zlib1g-dev libelf-dev libfl-dev python3-distutils linux-headers-\$(uname -r)
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg2
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl cmake libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libopencv-dev git
sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
# sudo swapoff -a
cd
git clone https://github.com/oakeshott/23PBL-A18-1.git
sudo reboot
EOF

chmod +x /etc/bootstrap.sh
chmod +x /etc/pyenv-installer.sh
chmod +x /etc/bcc-installer.sh
