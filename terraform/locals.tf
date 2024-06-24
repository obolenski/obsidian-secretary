locals {
  tags = {
    "repository"             = "https://github.com/obolenski/obsidian-secretary"
    "created_with_terraform" = "true"
    "application"            = "obsidian-secretary"
    "awsApplication"         = "arn:aws:resource-groups:eu-central-1:${var.account_number}:group/obsidian-secretary/02qnti2memrf2c6xtop2dmtmsj"
  }
}

variable "account_number" {
  type = string
}
