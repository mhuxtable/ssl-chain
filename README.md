# Local openssl SSL chain verification tool

This is a modified version of Kevin Decherf's
[`ssl_chain.sh`](https://kdecherf.com/blog/2015/04/10/show-the-certificate-chain-of-a-local-x509-file/)
tool which adds support for loading certificate chains for verification from
STDIN.

I use this to inspect the certificate chain of TLS certificates stored in
Kubernetes in conjunction with the great YAML parsing tool
[`yq`](https://github.com/mikefarah/yq), for example, on macOS:

```shell
kubectl get secret my-tls-secret | yq r - data[tls.crt] | base64 -D | ssl_chain.sh -
```
