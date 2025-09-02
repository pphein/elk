# ELK

ref - [Medium Blog](https://medium.com/@mehmetkanus17/how-to-deploy-elastic-stack-filebeat-logstash-elasticsearch-and-kibana-on-kubernetes-using-f6c763037da6)

microk8s.helm3 repo add elastic <https://helm.elastic.co>

microk8s.kubectl create namespace elasticsearch

microk8s.kubectl get storageclass
microk8s enable storage
microk8s.kubectl get storageclass

microk8s.kubectl get pvc
microk8s.kubectl apply -f pvc.yaml
microk8s.kubectl get pvc

microk8s.helm3 upgrade --install elastic elastic/elasticsearch --version 8.5.1 -f ./elk/elasticsearch/values.yaml -n elasticsearch

microk8s.helm3 upgrade --install logstash elastic/logstash --version 8.5.1 -f elk/logstash/values.yaml -n elasticsearch

microk8s.helm3 upgrade --install filebeat elastic/filebeat --version 8.5.1 -f  elk/filebeat/values.yaml -n elasticsearch

microk8s.helm3 upgrade --install kibana elastic/kibana --version 8.5.1 -f elelk/kibana/values.yaml -n elasticsearch

microk8s.helm3 upgrade --install metricbeat elastic/metricbeat --version 8.5.1 -f elk/metricbeat/values.yaml -n elasticsearch

microk8s.kubectl get pods --namespace=elasticsearch -w

microk8s.kubectl port-forward --address 0.0.0.0 svc/kibana-kibana 8080:5601 -n elasticsearch

microk8s.kubectl expose svc kibana-kibana -n elasticsearch   --type=NodePort --name=kibana-nodeport
microk8s.kubectl get svc -n elasticsearch kibana-nodeport
