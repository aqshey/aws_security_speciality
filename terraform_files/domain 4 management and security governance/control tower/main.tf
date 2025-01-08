provider  "aws" {
  region = "us-east-1"
}

// create control tower
resource "aws_ssoadmin_account_assignment" "account_assignment" {
  instance_arn = aws_ssoadmin_instance.instance.arn
  target_id    = aws_organizations_account.account.id
  target_type  = "AWS_ACCOUNT"
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn

  //TODO: Add principal_id and principal_type has to be filled
  principal_id = ""
  principal_type = ""
}

resource "aws_ssoadmin_permission_set" "permission_set" {
  name = "my-permission-set"
  //TODO: Add inline_policy has to be filled
  instance_arn = aws_ssoadmin_instance.instance.arn
}

resource "aws_ssoadmin_instance" "instance" {
  identity_store_id = aws_ssoadmin_identity_store.identity_store.id
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"
}

resource "aws_ssoadmin_identity_store" "identity_store" {
  identity_store_name = "my-identity-store"
  identity_store_type = "S3"
}

resource "aws_organizations_account" "account" {
  name = "my-account"
  email = "abc@testemail.com"
    parent_id = aws_organizations_organizational_unit.ou.id
}

resource "aws_organizations_organizational_unit" "ou" {
  name = "my-ou"
  parent_id = aws_organizations_organization.org.roots.0.id
}

resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}
