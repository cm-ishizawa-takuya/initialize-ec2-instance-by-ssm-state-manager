module "ansible_bucket" {
  source = "./modules/s3_bucket"
  bucket = "ansible-playbook-bucket-${local.account_id}"
}

module "ssm_log_bucket" {
  source = "./modules/s3_bucket"
  bucket = "ssm-log-bucket-${local.account_id}"
}

data "archive_file" "ansible" {
  type        = "zip"
  source_dir  = "./ansible"
  output_path = local.playbook_archive_file_path
}

resource "aws_s3_object" "ansible" {
  bucket = module.ansible_bucket.name
  key    = local.playbook_file_name
  source = local.playbook_archive_file_path
  etag   = data.archive_file.ansible.output_md5

  depends_on = [
    module.ansible_bucket
  ]
}