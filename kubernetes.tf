provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}




resource "kubernetes_deployment" "flask-deployment" {
  metadata {
    name = "flask"
    labels = {
      App = "flask"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "flask"
      }
    }
    template {
      metadata {
        labels = {
          App = "flask"
        }
      }
      spec {
        container {
          image = "moshikb/flaskapp:latest"
          name  = "flask"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask-service" {
  metadata {
    name = "flask"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask-deployment.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 5000
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}