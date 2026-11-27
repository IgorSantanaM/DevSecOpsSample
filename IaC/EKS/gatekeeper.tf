resource "helm_release" "gatekeeper" {
  depends_on       = [module.eks, module.vpc]
  name             = "gatekeeper"
  repository       = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart            = "gatekeeper"
  version          = "3.15.0"
  namespace        = "gatekeeper-system"
  create_namespace = true
}