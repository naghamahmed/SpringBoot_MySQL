# SpringBootApp

Mysql and SpringBoot app deployed on minikube cluster, 
Deployed the App through Helm Charts with GitLab CI
- Bulding SpringBoot images.
- Pushing image to Nexus Docker Repositaries. 
- Using GitLab-ci for building and deploying
- Using Helm Chart to deploy the app on minikube

# Project Component

- OS Ubuntu 24.04
- minikube v1.33.1
- Docker version 26.1.3
- ansible [core 2.16.7]
- GitLab CC
- Nexus3
- Helm v3

# Infrastructure

- Installing Docker
- Installing minikube
- Installing Ansible
- Installing Nexus using Ansible
- Installing Helm

# minikube Installation


1) Update Your System

```
sudo apt update
```

```
sudo apt upgrade -y
```
2) Install Docker

```
sudo apt install ca-certificates curl gnupg wget apt-transport-https -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
```

```
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Add your local user to docker group so that your local user run docker commands without sudo.

```
sudo usermod -aG docker $USER
newgrp docker
```
3) Download and Install Minikube Binary

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

To verify the minikube version, run

```
minikube version
```

4) Install Kubectl tool


```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
```
```
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

5) Start Minikube Cluster

```
minikube start --driver=docker
```
Creating two ns dev,test in the cluster

```
kubectl create ns dev
kubectl create ns test
```
5) Installing Helm

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```


# Applying Ansible (IAC)

Due to Specification of minikube rather than installing Nexus as a pod, Nuxus will be installed as a service using Ansible

```
ansible-playbook Nexus-Ansible/nexus.yaml
```
accessing Nexus through url

```
localhost:8081
```

Creating hosted docker repo on port 8082

Adding /etc/docker/daemon.json to allow pushing images to insecure registry

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

# Configuring Docker registry in Helm Chart

creating .dockerconfigjson with nexus credentials for image pull secret or using cli

```
kubectl create secret docker-registry nexus-registry-secret --docker-server=localhost:8082 --docker-username=<your-name> --docker-password=<your-password> --docker-email=<your-email>
```

# Gitlab server and Runner

- Installing Docker Compose

```
sudo yum install docker-compose-plugin
```

```
docker compose up
```
Acessing GitLab Server through url

```
localhost:80
```
- Creating Group and project within the group

# Configuring GitLab Runner

Creating instance runner in GitLab server and add the token through exec  GitLab runner container

```  
docker exec -it gitlab-runner gitlab-runner register --docker-privileged
```
