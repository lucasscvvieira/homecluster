# Rook Ceph

O Ceph é um software de armazenamento distribuido muito eficiente.

## Pré-requisito

Segundo a [documentação](https://rook.io/docs/rook/v1.9/Getting-Started/Prerequisites/prerequisites/#lvm-package) precisamos instalar o `lvm`.
```shell
sudo apt install -y lvm2
```

### Preparando os discos

Segundo a [documentação](https://rook.io/docs/rook/latest/Storage-Configuration/ceph-teardown/#zapping-devices) precisamos executar alguns comandos para preparar os discos.
```shell
# instala as dependências
sudo apt install gdisk

# Apaga o disco
sudo sgdisk --zap-all /dev/sda

# apaga os metadados LVM
dd if=/dev/zero of=/dev/sda bs=1M count=100 oflag=direct,dsync

# Informa o sistema operacional das mudanças
sudo partprobe $DISK
```

## Deploy

Vamos utilizar a versão [`1.9.10`](https://github.com/rook/rook/tree/release-1.9/deploy/examples).

```shell
# faz o deploy do operator
kubectl create -f common.yaml -f crds.yaml -f operator.yaml

# faz o deploy do cluster
kubectl create -f cluster.yaml
```

## Toolbox

```shell
# deploy do container
kubectl create -f toolbox.yaml

# acessar o container
kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
```

## Dashboard

Para acessar a dashboard vamos fazer o port-forward através do comando:
```shell
kubectl port-forward --address=0.0.0.0 -n rook-ceph service/rook-ceph-mgr-dashboard 8080:7000
```

Com o comando conseguimos acessar a dashboard do ceph através da url [http://localhost:8080](http://localhost:8080). O acesso padrão é:
```shell
# usuário é `admin` e a senha é dada pela saída do comando
kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo
```
