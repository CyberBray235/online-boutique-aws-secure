## Approach

Ce projet part d’un objectif simple : construire une plateforme Cloud/DevOps complète autour de l’application Online Boutique, en passant d’un simple déploiement Kubernetes à une plateforme plus mature intégrant GitOps, observabilité et sécurité. L’idée n’était pas seulement de faire tourner l’application, mais de montrer une progression vers une architecture plus propre, plus automatisée et plus exploitable.

### Design principles

Plusieurs principes ont guidé l’approche du projet :

- Passage d’une logique applicative plus couplée vers une approche distribuée et mieux découpée.
- Réflexion inspirée des concepts de Domain-Driven Design pour mieux comprendre les frontières fonctionnelles des services.
- Utilisation d’une logique proche de l’Event Storming comme outil de réflexion pour comprendre les flux métier et les interactions entre composants.
- Validation locale des manifests Kubernetes avant intégration dans la chaîne de déploiement.
- Passage progressif d’un déploiement manuel à une approche déclarative avec Kustomize et GitOps.

### Architecture layers

Le projet a été pensé en plusieurs couches complémentaires :

- **Infrastructure layer**: VPC, subnets publics et privés, NAT Gateway, IAM, EKS, ECR, provisionnés avec Terraform.
- **Platform layer**: Kubernetes, Argo CD, Ingress / ALB, Prometheus, Grafana et Alertmanager.
- **Security layer**: IAM least privilege, KMS, CloudTrail, AWS Config, GuardDuty EKS, scans d’images, logs d’audit.

### Delivery phases

Le projet a été structuré en deux phases principales :

#### Phase 1 — Functional deployment

Cette première phase avait pour objectif de rendre l’application opérationnelle sur AWS avec une chaîne de déploiement fonctionnelle. Elle couvre Terraform pour l’infrastructure, Docker pour le build, Amazon ECR pour le registre, Kubernetes pour l’exécution, et GitHub Actions pour l’automatisation du build et du push des images.

#### Phase 2 — Differentiation layer

La seconde phase a consisté à enrichir le projet avec des éléments plus avancés et plus différenciants pour un portfolio DevOps. Elle inclut Argo CD pour le GitOps, Prometheus et Grafana pour l’observabilité, des briques de sécurité, des scans de vulnérabilités, des logs et audits AWS, ainsi qu’une documentation d’architecture plus propre.

### Implementation timeline

#### 18 March — Terraform project bootstrap

- Création de l’arborescence Terraform avec les fichiers minimaux.
- Mise en place des fichiers `providers.tf`, `variables.tf`, `terraform.tfvars`, `outputs.tf` et `main.tf`.

#### 19 March — Networking foundation

- Création des premières ressources réseau : VPC, NAT Gateway et Internet Gateway.

#### Terraform practice with modules

Pour consolider la pratique Terraform, des tests ont aussi été réalisés avec des modules communautaires afin de provisionner des ressources comme EC2 et S3, puis de récupérer leurs sorties avec des outputs.

#### 21 March — Container registry

- Création du registre Amazon ECR.
- Mise en place des règles de cycle de vie des images.

#### 24 March — Cluster access and first deployment

- Connexion au cluster EKS avec `aws eks update-kubeconfig`.
- Création du namespace `online-boutique`.
- Déploiement initial de l’application avec les manifests Kubernetes du projet source.
- Authentification Docker vers Amazon ECR.
- Premier cycle de build, tag et push des images.

### From manual deployment to GitOps

Au début, certaines mises à jour d’images étaient faites manuellement avec `kubectl set image`, ce qui était utile pour débloquer rapidement les premiers tests. Ensuite, cette approche a été remplacée par Kustomize afin de versionner les changements de tag dans Git et d’éviter les mises à jour manuelles sur le cluster.

Cette évolution a permis d’aligner le projet avec une logique GitOps plus propre : GitHub Actions met à jour les manifests, puis Argo CD réconcilie automatiquement ou manuellement l’état du cluster avec l’état déclaré dans Git.

### Operational lessons learned

Quelques points importants ont émergé pendant le projet :

- Après une destruction et recréation de l’infrastructure, il faut vérifier que les ressources AWS ont bien été reconstruites.
- Il faut aussi vérifier que les images custom existent toujours dans ECR avec les bons tags.
- Si une image manque, la bonne séquence consiste à rebuild, re-tag, push l’image dans ECR, puis relancer le déploiement concerné.