# edit cluster.yaml nodes.yaml, source .env
cluster_gateway_addr=10.2.0.22
cluster_dns_gateway_addr=10.2.0.222
cloudflare_gateway_addr=10.2.0.111
cloudflare_domain=dt9.qzz.io
resource=
namespace=
name=
CONTROL_PLANE_IP=10.2.0.10

# initial setup
task init
task configure
task bootstrap:talos # wait until ready
task bootstrap:apps # wait until cilium completed
kubectl get pods --all-namespaces --watch # ^


# debug
talosctl get disks --insecure --nodes 10.2.0.10 
talosctl get links -n 10.2.0.10 
cilium status
flux check
flux get sources git -A
flux get ks -A
flux get hr -A
nmap -Pn -n -p 443 ${cluster_gateway_addr} ${cloudflare_gateway_addr} -vv
dig @${cluster_dns_gateway_addr} echo.${cloudflare_domain}
kubectl -n network describe certificates
kubectl -n ${namespace} get pods -o wide
kubectl -n ${namespace} logs ${pod_name} -f
kubectl -n ${namespace} describe ${resource} ${name}
kubectl -n ${namespace} get events --sort-by='.metadata.creationTimestamp'


# update talos or add node mode=auto
task talos:generate-config
task talos:apply-node IP=${CONTROL_PLANE_IP} MODE=auto
task talos:upgrade-node IP=${CONTROL_PLANE_IP}
task talos:upgrade-k8s



# Github Repo > Settings/Webhooks" press the "Add webhook" button. Fill in the webhook URL and your token from github-push-token.txt, Content type: application/json, Events: Choose Just the push event
kubectl -n flux-system get receiver github-webhook --output=jsonpath='{.status.webhookPath}'
https://flux-webhook.dt9.qzz.io/hook/63beef25ed078c3c8b8d2481496bbc6cbcb18ccae3b700ed33f2ab2c0861bf37
