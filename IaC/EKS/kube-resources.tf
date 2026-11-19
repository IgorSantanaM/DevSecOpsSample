provider "kubernetes" {
    host: module.eks.cluster_endpoint
    cluster_ca_certificate: base64decode(module.eks.cluster_certificate_authority_data)

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

resource "kubernetes_namespace" "online-boutique" {
    metadata {
        name = "online-boutique"
    }
}

resource "kubernetes_role" "namespace-viewer"{
    metadata {
        name = "namespace-viewer"
        namespace = kubernetes_namespace.online-boutique.metadata[0].name
    }

    rule {
        api_groups = [""]
        resources = ["pods", "services", "configmaps", "secrets", "persistentvolumeclaims", "events", "endpoints", "replicationcontrollers", "resourcequotas", "limitranges"]
        resource_names = ["foo"]
        verbs = ["get", "list", "watch", "describe"]
    }

    rule {
        api_groups = ["apps"]
        resources = ["deployments"]
        verbs = ["get", "list"]
    }
}

resource "kubernetes_role_binding" "namespace-viewer-binding" {
    metadata {
        name = "namespace-viewer-binding"
        namespace = kubernetes_namespace.online-boutique.metadata[0].name
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "Role"
        name = kubernetes_role.namespace-viewer.metadata[0].name
    }

    subject {
        kind = "User" 
        name = "developer"
        api_group = "rbac.authorization.k8s.io"
    }
}

resource "kubernetes_role" "cluster_viewer" {
    metadata {
        name = "cluster-viewer"
    }

    rule {
        api_groups = [""]
        resources = ["nodes", "namespaces"]
        verbs = ["get", "list", "watch"]
    }
}

resource "kubernetes_role_binding" "cluster-viewer-binding" {
    metadata {
        name = "cluster-viewer-binding"
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "Role"
        name = kubernetes_role.cluster_viewer.metadata[0].name
    }

    subject {
        kind = "User" 
        name = "admin"
        api_group = "rbac.authorization.k8s.io"
    }
}