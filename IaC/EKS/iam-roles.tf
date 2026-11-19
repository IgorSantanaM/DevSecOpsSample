locals {
    aws_k8s_role_mapping = [{

        rolearn = aws_iam_role.external-admin.arn
        username = "admin"
        groups = ["system:masters"]
        }
    ]
}

resource "aws_iam_role" "external-admin" {
    name = "external-admin"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    AWS = var.external_admin_arn 
                }
            },
        ]
    })

    inline_policy {
        name = "external-admin-policy"
        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action = [
                        "eks:DescribeCluster",
                        "eks:ListClusters",
                        "eks:ListNodegroups",
                        "eks:DescribeNodegroup",
                        "eks:ListUpdates",
                        "eks:DescribeUpdate",
                        "eks:AccessKubernetesApi"
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
        })
    }
}

resource "aws_iam_role" "external-dev" {
    name = "external-dev"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    AWS = var.external_dev_arn 
                }
            },
        ]
    })

    inline_policy {
        name = "external-dev-policy"
        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action = [
                        "eks:DescribeCluster",
                        "eks:ListClusters",
                        "eks:ListNodegroups",
                        "eks:DescribeNodegroup",
                        "eks:ListUpdates",
                        "eks:DescribeUpdate",
                        "eks:AccessKubernetesApi"
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
        })
    }
}