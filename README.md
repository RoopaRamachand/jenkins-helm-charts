# JupiterOne jenkins Helm Charts

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add jenkins-scripts https://rooparamachand.github.io/jenkins-helm-charts/
helm repo update
helm install job-name jenkins-scripts/jenkins-scripts --set secrets.jenkinsURL=https://jenkins-server-api --set secrets.jenkinsUser=userid --set secrets.jenkinsPassword=userpassword --set secrets.jupiteroneAccountId=jupiterone-account-id --set secrets.jupiteroneApiKey=j1token
```
You can then run `helm search repo jenkins-scripts` to see the charts.
