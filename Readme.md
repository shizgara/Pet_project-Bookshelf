Pet Pjoject - Bookshelf
The application is based on the Flask framework and written using Python language
GCP + Terraform + Ansible + Python + FluentD(logging&monotoring)
GCP - as a Cloud Provider
Terraform - as infrastructure as a code software tool
Ansible - for software provisioning, configuration management, and application deployment
Cloud SQL - for application data backend
Fluentd agent - for monitoring and application logging

All folders must be in GCP Cloud Source Repositories with special permissions

Lunch on vm instance in GCP:
1. Clone bookshelf_terraform
2. cd /bookshelf_terraform
3. terraform init
4. terraform apply

After you will have:
1. Single VPC + subnetwork + firewall rulles
2. Bucket for storing images
3. Sql Instace for data backend
4. Manage Instance Group(with APP) + Load balancer