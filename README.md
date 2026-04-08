# Online Boutique AWS Secure

Projet **Cloud / DevOps** de bout en bout autour de l'application *Online Boutique* déployée sur Kubernetes avec une chaîne complète CI/CD, GitOps et observabilité. Le dépôt montre comment construire une image Docker, la publier dans Amazon ECR, mettre à jour les manifests Kustomize via GitHub Actions, puis laisser Argo CD synchroniser automatiquement ou manuellement l'état du cluster à partir de Git.

## Aperçu

Ce projet met en œuvre une architecture DevOps moderne autour de plusieurs briques complémentaires : AWS pour l'infrastructure et le registre d'images, Kubernetes pour l'orchestration, GitHub Actions pour la CI, Argo CD pour le GitOps, et Prometheus/Grafana pour la supervision.

## Stack technique

- AWS ECR, pour stocker les images Docker.
- Kubernetes, pour exécuter les microservices.
- Kustomize, pour gérer les overlays d'environnement.
- GitHub Actions, pour builder, tagger et publier les images puis mettre à jour les manifests Git.
- Argo CD, pour synchroniser l'état désiré depuis Git vers le cluster Kubernetes.
- Prometheus + Grafana, pour les métriques, dashboards et alertes.
- Terraform, pour l'infrastructure as code du projet.

## Architecture

Le dépôt contient le code applicatif, les manifests Kubernetes, l'infrastructure Terraform et la pipeline CI/CD. Les diagrammes Mermaid sont particulièrement adaptés aux README GitHub car ils sont rendus nativement et restent faciles à maintenir en texte.

```mermaid
flowchart LR
    Dev[Developer] --> GitHub[GitHub Repository]
    GitHub --> GHA[GitHub Actions]
    GHA --> Docker[Docker Build]
    Docker --> ECR[Amazon ECR]
    GHA --> Kustomize[Kustomize Overlay Update]
    Kustomize --> GitOps[Commit manifest update]
    GitOps --> Argo[Argo CD]
    Argo --> EKS[Kubernetes Cluster]
    EKS --> App[Online Boutique]
    EKS --> Prom[Prometheus]
    Prom --> Graf[Grafana]
```

## Architecture Devops

Cette architecture présente l’environnement AWS, le cluster EKS, la chaîne CI/CD avec GitHub Actions et Amazon ECR, le déploiement GitOps avec Argo CD, ainsi que la supervision via Prometheus et Grafana.

<p align="center">
  <img src="/images/project-architecture.png" alt="Architecture globale du projet Online Boutique AWS Secure" width="100%">
</p>

## Flux CI/CD

Le pipeline suit une logique GitOps simple : un changement sur le frontend déclenche un build d'image, l'image est poussée dans ECR, puis le tag est injecté dans l'overlay Kustomize avant d'être poussé dans Git. Argo CD détecte alors ce nouveau commit et resynchronise l'application dans le cluster.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant ECR as Amazon ECR
    participant Repo as Git Repository
    participant Argo as Argo CD
    participant K8s as Kubernetes

    Dev->>GH: Push sur main
    GH->>GHA: Déclenche workflow frontend-build
    GHA->>GHA: Build image Docker
    GHA->>ECR: Push image taggée
    GHA->>Repo: Met à jour kustomization.yaml
    Repo->>Argo: Nouveau commit détecté
    Argo->>K8s: Sync de l'état désiré
    K8s-->>Dev: Application mise à jour
```

## Observabilité

La supervision repose sur Prometheus pour la collecte des métriques et Grafana pour leur visualisation. Cette combinaison est une pratique courante pour le monitoring Kubernetes et permet de suivre l'état des nœuds, des pods, des workloads et d'ajouter des alertes opérationnelles utiles.
```mermaid
flowchart LR
    K8s[Kubernetes Cluster] --> KSM[kube-state-metrics]
    K8s --> NodeExp[node-exporter]
    KSM --> Prom[Prometheus]
    NodeExp --> Prom
    Prom --> Graf[Grafana Dashboards]
    Prom --> Alerts[Alert Rules]
```

## Structure du dépôt

```text
.
├── .github/workflows/                  # Workflows GitHub Actions
├── microservices-demo/                 # Code source de l'application
├── online-boutique-aws-secure/k8s/     # Manifests Kubernetes et overlays Kustomize
├── terraform/                          # Infrastructure as Code
└── Documentation/                      # Documentation complémentaire
```

## Fonctionnalités réalisées

- Build et push automatique de l'image frontend dans Amazon ECR.
- Mise à jour automatique du tag d'image dans `kustomization.yaml` via GitHub Actions.
- Déploiement GitOps avec Argo CD à partir du dépôt Git.
- Dashboards Grafana pour les métriques système et Kubernetes.
- Base de supervision prête pour des alertes sur pods, disponibilité et mémoire.

## Déploiement

### 1. Build et push de l'image

Le workflow GitHub Actions construit l'image frontend et la pousse dans ECR à chaque modification du frontend ou du workflow concerné.

### 2. Mise à jour des manifests

Après le push de l'image, le workflow met à jour l'overlay Kustomize dans `online-boutique-aws-secure/k8s/overlays/dev/app/` afin que Git reste la source de vérité du déploiement.

### 3. Synchronisation Argo CD

Argo CD compare l'état réel du cluster avec l'état déclaré dans Git, détecte les écarts et applique la synchronisation demandée ou automatique selon la politique choisie.

## Monitoring

La stack `kube-prometheus-stack` fournit une base complète pour superviser le cluster et les workloads Kubernetes. Grafana peut ensuite consommer Prometheus comme source de données pour afficher des dashboards communautaires ou personnalisés.

Exemples de dashboards utiles :

- Node Exporter Full.
- Kubernetes Dashboard.
- Kubernetes Monitoring Dashboard.

## Ce projet démontre

- CI/CD moderne sur GitHub Actions.
- Gestion déclarative de Kubernetes avec Kustomize.
- GitOps avec Argo CD.
- Observabilité avec Prometheus et Grafana.
- Structuration claire d'un dépôt technique avec README et schémas Mermaid, ce qui améliore la lisibilité et la maintenance du projet.

## Améliorations possibles

- Ajouter un environnement `staging` séparé avec un overlay Kustomize dédié.
- Ajouter des alertes Grafana ou Alertmanager plus avancées sur les pods et les déploiements.
- Instrumenter les microservices avec de vraies métriques applicatives Prometheus afin d'aller au-delà du monitoring infra/Kubernetes.
- Ajouter des captures d'écran Grafana et Argo CD dans le dépôt pour renforcer la démonstration visuelle du projet.

## Démarrage rapide

```bash
# Cloner le dépôt
 git clone <repo-url>
 cd <repo>

# Déployer les manifests Kubernetes
 kubectl apply -k online-boutique-aws-secure/k8s/overlays/dev/app

# Accéder à Argo CD
 kubectl port-forward svc/argocd-server -n argocd 8081:443

# Accéder à Grafana
 kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80
```

## Captures à ajouter dans le repo
### Argo CD
![Application Argo CD synchronisée et healthy](/images/argocdsync.png)
![Application Argo CD synchronisation auto](/images/argocd2.png)

### Application
![Interface Online Boutique déployée](/images/boutique.png)

### Monitoring
![Dashboard Grafana Kubernetes](/images/grafana.png)

## Licence
BRAY MADOUE KAGONGBE