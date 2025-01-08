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
    },
    "MySecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow HTTP traffic",
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "10.0.0.1/32"

            }
            ]
        }
    },

    "MyLoadBalancer": {
      "Type": "AWS::ElasticLoadBalancingV2::LoadBalancer",
      "Properties": {
        "Subnets": ["subnet-12345678", "subnet-87654321"],
        "SecurityGroups": ["sg-12345678"],
        "Type": "application"
      }
    },

    "MyListener": {
      "Type": "AWS::ElasticLoadBalancingV2::Listener",
      "Properties": {
        "DefaultActions": [
          {
            "Type": "forward",
            "TargetGroupArn": { "Ref": "MyTargetGroup" }
          }
        ],
        "LoadBalancerArn": { "Ref": "MyLoadBalancer" },
        "Port": 80,
        "Protocol": "HTTP"
      }
    },

    "MyTargetGroup": {
      "Type": "AWS::ElasticLoadBalancingV2::TargetGroup",
      "Properties": {
        "Port": 80,
        "Protocol": "HTTP",
        "TargetType": "instance",
        "VpcId": "vpc-12345678"
      }
    }
    }
    }
EOF
}
