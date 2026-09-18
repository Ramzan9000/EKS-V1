resource "kubernetes_manifest" "root_app" {
  manifest = yamldecode(file("${path.module}/root-app.yaml"))

  lifecycle {
    ignore_changes = [manifest]
  }
}
