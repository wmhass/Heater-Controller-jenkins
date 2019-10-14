chmod -R 777 /var/run/docker.sock
cp /var/ssh_keys/id_rsa /var/jenkins_home/.ssh/
chmod 600 /var/jenkins_home/.ssh/id_rsa
