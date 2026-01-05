#!/bin/bash
/usr/sbin/useradd -s /bin/bash -m ritesh;
mkdir /home/ritesh/.ssh;
chmod -R 700 /home/ritesh;
echo "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ritesh@DESKTOP-0XXXXXX" >> /home/ritesh/.ssh/authorized_keys;
chmod 600 /home/ritesh/.ssh/authorized_keys;
chown ritesh:ritesh /home/ritesh/.ssh -R;
echo "ritesh  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/ritesh;
chmod 440 /etc/sudoers.d/ritesh;

#################################################################### DevOps Agent ###########################################################################

useradd -s /bin/bash -m demo;
echo "Password@#795" | passwd demo --stdin;
yum install -y vim wget zip unzip java-17* git yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io && systemctl start docker && systemctl enable docker
chown demo:demo /var/run/docker.sock
cd /opt/ && wget https://dlcdn.apache.org/maven/maven-3/3.9.12/binaries/apache-maven-3.9.12-bin.tar.gz
tar -xvf apache-maven-3.9.12-bin.tar.gz
rm -f apache-maven-3.9.12-bin.tar.gz
mv /opt/apache-maven-3.9.12 /opt/apache-maven
cd /opt && wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
unzip sonar-scanner-cli-4.8.0.2856-linux.zip
rm -f sonar-scanner-cli-4.8.0.2856-linux.zip
mv /opt/sonar-scanner-4.8.0.2856-linux/ /opt/sonar-scanner
cd /opt && wget https://nodejs.org/dist/v16.0.0/node-v16.0.0-linux-x64.tar.gz
tar -xvf node-v16.0.0-linux-x64.tar.gz
rm -f node-v16.0.0-linux-x64.tar.gz
mv /opt/node-v16.0.0-linux-x64 /opt/node-v16.0.0
cd /opt && wget https://github.com/jeremylong/DependencyCheck/releases/download/v8.4.0/dependency-check-8.4.0-release.zip
unzip dependency-check-8.4.0-release.zip
rm -f dependency-check-8.4.0-release.zip
chown -R demo:demo /opt/dependency-check
cd /opt && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.68.2
echo JAVA_HOME="/usr/lib/jvm/java-17-openjdk-17.0.15.0.6-2.el8.x86_64" >> /home/demo/.bashrc
echo PATH="$PATH:$JAVA_HOME/bin:/opt/sonar-scanner/bin:/opt/apache-maven/bin:/opt/node-v16.0.0/bin:/opt/dependency-check/bin:/usr/local/bin" >> /home/demo/.bashrc
echo "demo  ALL=(ALL)  NOPASSWD:ALL" >> /etc/sudoers 
yum install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
yum install -y azure-cli

##################################### Install OpenTofu ################################################

cd /opt/ && curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method rpm
rm -f install-opentofu.sh
tofu --version
echo "OpenTofu installed successfully."

########################################################################################################

mkdir /mederma;
mkfs.xfs /dev/sdc;
echo "/dev/sdc  /mederma  xfs  defaults 0 0" >> /etc/fstab;
mount -a;

