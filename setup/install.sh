yum update -y

# vi /etc/selinux/config
SELINUX=disabled
# shutdown -r now

# https://dev.mysql.com/downloads/repo/yum/
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum remove -y mariadb-libs
yum install -y mysql-community-server mysql-community-devel
# chown mysql:mysql /var/lib/mysql
sudo mysqld --initialize-insecure
sudo mysql_secure_installation
# systemctl start mysqld

rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum --enablerepo=remi install -y redis
# systemctl start redis

cat << EOS >>/etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1
EOS
yum install -y nginx
cp ./setup/nginx.conf /etc/nginx/conf.d/transcription.conf
# systemctl start nginx

yum groupinstall -y "Development Tools"
yum install -y wget git tmux dstat htop monit tree
yum install -y openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

# Install ruby2.7.0
# https://github.com/egotter/egotter/wiki/Install-Ruby

yum install -y ruby-devel

cat << EOS >>/etc/security/limits.conf
root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536
EOS

echo "net.ipv4.tcp_max_syn_backlog = 512" >>/etc/sysctl.conf
echo "net.core.somaxconn = 512" >>/etc/sysctl.conf
echo "vm.overcommit_memory = 1" >>/etc/sysctl.conf
sysctl -p

echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >>/etc/rc.local

git clone https://github.com/ts-3156/transcription.git
chown -R ec2-user:ec2-user transcription
# cd transcription

bundle config set path '.bundle'
bundle config set without 'test development'
bundle install

curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
yum install -y nodejs yarn

yarn install --check-files
# Copy config/master.key and .env
RAILS_ENV=production bundle exec rails db:create db:migrate db:seed assets:precompile

bundle exec rails s -e production
# RAILS_ENV=production bundle exec pumactl start

cp ./setup/sidekiq.systemd.service /usr/lib/systemd/system/sidekiq.service
# systemctl start sidekiq

# ffmpeg, ffprobe
rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum install -y ffmpeg ffmpeg-devel
# ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 [SRC]
# ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 [SRC]

# sox
yum remove -y sox
yum install y gcc-c++ libmad libmad-devel libid3tag libid3tag-devel lame lame-devel flac-devel libvorbis-devel
wget -O sox-14.4.2.tar.gz https://sourceforge.net/projects/sox/files/sox/14.4.2/sox-14.4.2.tar.gz/download
tar xvfz sox-14.4.2.tar.gz
cd sox-14.4.2
./configure && make && make install
# sox [SRC] --rate 16k --bits 16 --channels 1 [DST]

# python3
yum install -y python3 python3-devel
pip3 install google-cloud-speech
