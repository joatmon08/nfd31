network-test:
	terraform output -raw test_variables > test/integration/terraform.auto.tfvars
	cd test/integration && terraform init
	cd test/integration && terraform apply
	cd test/integration && terraform destroy