# solr-helm

This project provides a Helm chart for deploying Solr Master/Slave topology on Kubernetes.

## Components

There are 4 components will be created:

* `solr-master` - StatefulSet with default 1 replica, accept both write and read
* `solr-slave` - StatefulSet with default 2 replicas, will only accept read, async poll from master
* `solr-master-service` - for slave to discover master. Change type to "LoadBalancer" if want external access
* `solr-slave-service` - for read operation

## Quickstart

### Step 1 - Download Helm Chart Repository

```
git clone https://github.com/liwang-pivotal/solr-helm
```

### Step 2 - (Optional) Grant permission to Tiller if necessary

```
$ kubectl create serviceaccount --namespace kube-system tiller

$ kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

$ kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

### Step 3 - Install Solr Helm Chart

```
helm install solr-helm
```

## Smoke Test

1. Edit Solr Master/Slave Service and Change Service Type from "type: ClusterIP" to “type: LoadBalancer”

```
$ kubectl edit svc RELEASE_NAME-solr-master
```

2. Load data:

```
$ curl "http://{{MASTER_EXTERNAL_IP}}:8983/solr/test/update" -H "Content-Type: text/xml" --data-binary '
<add>
  <doc>
    <field name="authors">Patrick Eagar</field>
    <field name="subject">Sports</field>
    <field name="dd">796.35</field>
    <field name="isbn">0002166313</field>
    <field name="yearpub">1982</field>
    <field name="publisher">Collins</field>
  </doc>
</add>'

$ curl "http://{{MASTER_EXTERNAL_IP}}:8983/solr/test/update" --data '<commit/>'
```

3. Read data:

```
$ curl "http://{{MASTER_EXTERNAL_IP}}:8983/solr/test/select?q=*:*"

$ curl "http://{{SLAVE_EXTERNAL_IP}}:8983/solr/test/select?q=*:*"
```

# About this repository

This repository is based on `liwang0513/solr-docker`
