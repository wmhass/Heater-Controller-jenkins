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

# copy entrypoint.sh
COPY ./entrypoint.sh /usr/local/var/entrypoint.sh
RUN chmod +x /usr/local/var/entrypoint.sh

# run entrypoint.sh
ENTRYPOINT ["/usr/local/var/entrypoint.sh"]

CMD ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
