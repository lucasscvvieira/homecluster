# homecluster

Esse repositório contem todos as configurações e arquivos de configurações utilizados para criar o cluster kubernetes.

---

## Preparação dos Raspberrys

Vamos utilizar a distribuição [Debian](https://raspi.debian.net/daily-images/) porque kernel dela trás alguns módulos que serão necessários quando configurarmos o armazenamento.

Antes de qualquer coisa, vamos configurar o acesso SSH pra não precisar ficar com o teclado, mouse e monitor conectado nos raspberrys. Para fazer isso basta rodar os comandos:
```shell
hostnamectl set-hostname k3s-01
systemctl enable --now ssh
```

```shell
apt install locales

# editar e descomentar o en_US.UTF-8 e o pt_BR.UTF-8
nano /et/locale.gen
locale-gen
localectl set-locale LANG=pt_BR.UTF-8

timedatectl set-timezone America/Sao_Paulo
```

Agora vamos atualizar o nosso sistema operacional e instalar algumas dependências:
```shell
apt update && apt upgrade -y
apt install -y sudo curl wget
```

Vamos adicionar um usuário para não ficar fazendo coisas no root:
```shell
# cria o grupo k3s
groupadd -g 1000 k3s

# cria o usuário k3s
useradd -m -g 1000 -G sudo -u 1000 -s /usr/bin/bash k3s

# adiciona o usuário com permissão de sudo sem precisar de senha
echo "k3s ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/k3s
```

Para finalizar, precisamos habilitar o `cgroup` para maiores controles dos pods no Kubernetes:
```shell
echo "$(cat /boot/firmware/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" | sudo tee /boot/firmware/cmdline.txt
```

## Criação do Cluster

Vamos utilizar o [**k3s**](https://github.com/k3s-io/k3s/) como distribuição Kubernetes e para instalá-lo vamos utilizar o [**k3sup**](https://github.com/alexellis/k3sup). Antes de usar o **k3sup** primeiro vamos configurar o acesso SSH nos nossos nós para conectar via chave SSH. E para isso copiar a nossa chave para cada um dos nós com o comando:
```shell
ssh-copy-id k3s@192.168.0.101
```

Para instalar o **k3s** no nó master basta rodar o seguinte comando:
```shell
k3sup install --k3s-channel latest --k3s-extra-args '--flannel-backend=none --disable-network-policy --disable coredns,servicelb,traefik,local-storage,metrics-server' --cluster --ip 192.168.0.101 --merge --local-path ~/.kube/config --context k3s-homecluster --user k3s --ssh-key ~/.ssh/id_ed25519
```

Para instalar o *agent* é o comando:
```shell
k3sup join --k3s-channel latest --server-ip 192.168.0.101 --ip 192.168.0.102 --user k3s --ssh-key ~/.ssh/id_ed25519
```
