& ./package.ps1

cd ./terraform

terraform init

terraform apply -auto-approve

cd ..
