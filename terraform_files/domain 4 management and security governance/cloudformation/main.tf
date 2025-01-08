// create cloudformation which can deploy one ec2 instance with httpd server and this server should have index.html with hello world

provider "aws" {
  region = "eu-central-1"
}

resource "aws_cloudformation_stack" "stack" {
  name = "my-stack"
  template_body = <<EOF
{
  "Resources": {
    "MyInstance": {
      "Type": "AWS::EC2::Instance",
      "Properties": {
        "ImageId": "${data.aws_ami.amazon_linux.id}",
        "InstanceType": "t2.micro",
        "UserData": {
          "Fn::Base64": {
            "Fn::Join": [
              "",
              [
                "#!/bin/bash\n",
                "yum install -y httpd\n",
                "systemctl start httpd\n",
                "systemctl enable httpd\n",
                "echo '<h1>Hello, World</h1>' > /var/www/html/index.html\n"
              ]
            ]
          }
        }
      }
    }
  }
}

EOF
}

