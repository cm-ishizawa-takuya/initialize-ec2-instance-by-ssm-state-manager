resource "aws_ssm_association" "ansible" {
  name = "AWS-ApplyAnsiblePlaybooks"

  parameters = {
    SourceType = "S3",
    SourceInfo = jsonencode({
      path = "https://s3.amazonaws.com/${module.ansible_bucket.name}/${local.playbook_file_name}"
    }),
    PlaybookFile        = "site.yml",
    InstallDependencies = "True",
  }

  targets {
    key    = "InstanceIds"
    values = [aws_instance.web_server.id]
  }

  output_location {
    s3_bucket_name = module.ssm_log_bucket.name
  }

  depends_on = [
    aws_s3_object.ansible
  ]
}