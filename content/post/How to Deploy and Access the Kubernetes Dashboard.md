---
title: "How to Deploy and Access the Kubernetes Dashboard"
date: 2021-05-23T21:03:01+08:00
draft: true
tags:
  - "Kubernetes"
  - "Dashboard"
  - "k8s"
categories:
  - "HowTo"
summary: "Kubernetes Dashboard is a general purpose, web-based UI for Kubernetes clusters. It allows users to manage applications running in the cluster and troubleshoot them, as well as manage the cluster itself."
---

Dashboard is a web-based Kubernetes user interface. You can use Dashboard to deploy containerized applications to a Kubernetes cluster, troubleshoot your containerized application, and manage the cluster resources.
You can use Dashboard to get an overview of applications running on your cluster, as well as for creating or modifying individual Kubernetes resources (such as Deployments, Jobs, DaemonSets, etc).
For example, you can scale a Deployment, initiate a rolling update, restart a pod or deploy new applications using a deploy wizard.

Dashboard also provides information on the state of Kubernetes resources in your cluster and on any errors that may have occurred.

![Kubernetes Web UI (Dashboard)](/images/dashboard-ui.png)

# Deploying the Dashboard UI

The Dashboard UI is not deployed by default. To deploy it, run the following command:

``` bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
```

If you want to make some modifications to the file, you’ll have to download it to your local machine. And modify the file to fit your deployment needs.

We can use `kubectl get pods` to check the deployment status:

```
$ kubectl -n kubernetes-dashboard get pods
NAME                                         READY   STATUS    RESTARTS   AGE
dashboard-metrics-scraper-856586f554-r97q9   1/1     Running   0          73m
kubernetes-dashboard-78c79f97b4-k85ch        1/1     Running   0          73m
```

Two pods should be created – One for dashboard and another for metrics.

# Accessing the Dashboard UI

## Command line proxy

You can access Dashboard using the `kubectl` command-line tool by running the following command:

```
$ kubectl proxy --address='0.0.0.0' --accept-hosts='^.*$'
```

Kubectl will make Dashboard available at [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/).

The UI can only be accessed from the machine where the command is executed. See `kubectl proxy --help` for more options.

> Note: Kubeconfig Authentication method does NOT support external identity providers or x509 certificate-based authentication.

## NodePort

NodePort exposes the Service on each Node’s IP at a static port (the NodePort). A ClusterIP Service, to which the NodePort Service routes, is automatically created.

```
$ kubectl -n kubernetes-dashboard edit service kubernetes-dashboard
```

You should see yaml representation of the service. Change `type: ClusterIP` to `type: NodePort` and save file. If it's already changed go to next step.

Next we need to check port on which Dashboard was exposed.

```
$ kubectl -n kubernetes-dashboard get service kubernetes-dashboard
NAME                   TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
kubernetes-dashboard   NodePort   10.109.171.39   <none>        443:31060/TCP   84m
```

Dashboard has been exposed on port 31060 (HTTPS). Now we can access it from your browser at: `https://<master-ip>:31060`.
The master-ip can be found by executing `kubectl cluster-info`.
Usually it is either 127.0.0.1 or IP of your machine, assuming that your cluster is running directly on the machine, on which these commands are executed.

## API Server

If we want use this way to access Dashboard, we need to generate and install P12 certificates:

```
# 获取客户端证书，进行base64转码后保存到kubecfg.crt
grep 'client-certificate-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d > kubecfg.crt

# 获取客户端公钥，进行base64转码后保存到kubecfg.key
grep 'client-key-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d > kubecfg.key

# 提取kubecfg.crt和kubecfg.key文件内容，生成P12安全证书，并保存到kubecfg.p12文件
openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-client"

# 导入证书
sudo security import ./kubecfg.p12
```

> If we run this command on macOS, be sure to change the `base64 -d` to `base64 -D`

```
cat <<EOF> dashboard-anonymous.yml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kubernetes-dashboard-anonymous
rules:
- apiGroups: [""]
  resources: ["services/proxy"]
  resourceNames: ["https:kubernetes-dashboard:"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- nonResourceURLs: ["/ui", "/ui/*", "/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/*"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-anonymous
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubernetes-dashboard-anonymous
subjects:
- kind: User
  name: system:anonymous
EOF
```

## Ingress

Dashboard can be also exposed using Ingress resource. For more information check: [https://kubernetes.io/docs/concepts/services-networking/ingress](https://kubernetes.io/docs/concepts/services-networking/ingress).

# Conclusion

- **kubectl proxy**: Works locally, it can be tweaked to proxy remotely but, we would be exposing the dashboard to HTTP instead of HTTPS, so it is a really bad solution security-wise.
- **NodePort**: Only works for a single master node deployment, which is usually not the case for production systems.
- **API Server**: Is the preferred solution and the one we will describe. This way of accessing Dashboard is only possible if you choose to install your user certificates in the browser. In example certificates used by kubeconfig file to contact API Server can be used.

# See also

- [Creating sample user](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)
- [Kubernetes – unable to login to the Dashboard](https://www.australtech.net/kubernetes-unable-to-login-to-the-dashboard/)
- [accessing-dashboard.md - GitHub](https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md)

# References

- [kubernetes/dashboard - GitHub](https://github.com/kubernetes/dashboard)
- [Web UI (Dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
