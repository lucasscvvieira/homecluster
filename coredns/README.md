# CoreDNS

Para que os serviços se comuniquem pelo nome precisamos que seja criado um dns interno do cluster e para essa tarefa vamos utilizar o CoreDNS.

```shell
# adiciona o repositório helm do coredns
helm repo add coredns https://coredns.github.io/helm

# faz o deploy do CoreDNS
helm install coredns coredns/coredns --namespace=kube-system \
    --set resources.requests.memory=70Mi \
    --set service.clusterIP=10.43.0.10
```

Obs: Precisamos definir o `clusterIP` porque no **k3s** o serviço de dns precisa estar com o IP `10.43.0.10`, senão o cluster não reconhece o servidor DNS.
