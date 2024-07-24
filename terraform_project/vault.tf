# provider "vault" {
#   address = "http://localhost:8200"
#   token   = "your-vault-token"
# }
#
# data "vault_generic_secret" "xacct_report_other_acct" {
#   path = "secret/terraform"
# }
#
# locals {
#   xacct_report_other_acct = data.vault_generic_secret.xacct_report_other_acct.data["xacct_report_other_acct"]
# }