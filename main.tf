provider "google" {
  project = "encoded-adviser-393206"
  region = "europe-central2"
  credentials = "encoded-adviser-393206-32637e9b46fc.json"
}
resource "google_container_cluster" "test" {
  name = "cluster-test"
  location = "europe-central2"
  enable_autopilot = true
}
resource "google_container_cluster" "flask" {
  name = "flask-cluster"
  location = "europe-central2"
  enable_autopilot = true
}
