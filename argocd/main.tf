terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.7.0"
    }

    helm = {
      source  = "hashicorp/helm"
    }

  }
}

provider "helm" {
    kubernetes {
        config_path = "/etc/rancher/k3s/k3s.yaml"
    }
}


terraform {
 backend "s3" {
   bucket         = "<your-tfstate-bucket>""
   key            = "<your-bucket-key>""
   region         = "<your-aws-region>"
#   dynamodb_table = "terraform-state"
 }
}

resource "helm_release" "argocd" {
    name = "argocd"

    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    namespace  = "argocd" # otherwise might overwrite some variables in the chart
    version    = "5.35.0"
    create_namespace = true
    values     = [file("values.yaml")]
}