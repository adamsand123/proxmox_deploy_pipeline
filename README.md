# Run packer

[packer docs](packer/README.md)

init

```sh
cd packer/rhel && packer init .
```

Kör

```sh
cd packer/rhel && packer build -var-file=variables.pkrvars.hcl .
```

# Terraform

[terraform docs](terraform/README.md)

init terraform.

```sh
cd terraform && terraform init
```

deploy environment with terraform.

```sh
cd terraform && terraform apply
```

destroy environment with terraform.

```sh
cd terraform && terraform destroy
```
