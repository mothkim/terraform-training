# Outline #
What is terraform
Infrastructure as a Code (IaC) คืออะไร
จะเริ่มต้นใช้ Terraform อย่างไรดี
Developer Owner terraform
Provider support AWS Azure GoogleCloud kubernetes docker
About file
install terraform
Used terraform
- init
- plan
- validate
- apply
```sh
terraform apply
terraform apply -auto-approve
variable
terraform apply -var="nginx_external_port=8099"
```
- destoy
```sh
terraform destroy
terraform destroy --auto-approve
```
- plan
Manage Resource AWS
- init
- apply
- destoy
- plan

# Concern #
- Edit -> Apply = Resource re-create
- when Enter valus must be 'yes' not 'y'

---

## Run jenkins Docker ##

```sh
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home jenkins/jenkins
```