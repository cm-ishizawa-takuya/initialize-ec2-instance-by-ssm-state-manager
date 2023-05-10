locals {
  availability_zone          = data.aws_availability_zones.available.names[0]
  account_id                 = data.aws_caller_identity.current.account_id
  playbook_file_name         = "playbook.zip"
  playbook_archive_file_path = "./dest/${local.playbook_file_name}"
}