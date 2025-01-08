// create ou hierarchy

resource "aws_organizations_organizational_unit" "ou" {
  name = "my-ou"
  parent_id = aws_organizations_organization.org.roots.0.id
}

resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

resource "aws_organizations_account" "account" {
  name = "my-account"
  email = "abc@testemail.com"
    parent_id = aws_organizations_organizational_unit.ou.id
}
// apply best practices scp

resource "aws_organizations_policy" "policy" {
  name = "my-policy"
  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:PrincipalOrgID": "o-1234567890"
        }
      }
    }
  ]
}
EOF
}

resource "aws_organizations_policy_attachment" "attachment" {
  policy_id = aws_organizations_policy.policy.id
  target_id = aws_organizations_organizational_unit.ou.id
}

