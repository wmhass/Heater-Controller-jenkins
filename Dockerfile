FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
apt-get update && \
apt-get -y install docker-ce
RUN curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /bin/docker-compose
RUN sudo chmod +x /bin/docker-compose
RUN apt-get install -y docker-ce
RUN usermod -a -G docker jenkins
USER jenkins
ADD /var/ssh_keys/id_rsa /var/jenkins_home/.ssh/id_rsa
ADD /var/ssh_keys/id_rsa.pub /var/jenkins_home/.ssh/id_rsa.pub
