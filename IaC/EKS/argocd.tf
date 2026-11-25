provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name,
      ]
    }
  }
}

resource "helm_release" "argocd" {
   depends_on       = [module.eks]
   name             = "argocd"
   repository       = "https://argoproj.github.io/argo-helm"
   chart            = "argo-cd"
   version          = "6.4.0"
   namespace        = "argocd"
   create_namespace = true
}

resource "kubernetes_secret" "argocd_gitops_repo"{
    depends_on = [helm_release.argocd]
    metadata {
        name      = "gitops-k8s-repo"
        namespace = "argocd"
        labels    = {
            "app.argoproj.io/secret-type" = "repository"
        }
    }

    data = {
        type: "git"
        url: var.gitops_repo_url
        username: var.gitops_repo_username
        password: var.gitops_repo_password
    }
    type = "Opaque"
}