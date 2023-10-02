# -------------------------------------
# Terraform configuration
# -------------------------------------
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5.0"
    }
  }
}

# ******************************
# EC2 Instance - テスト用
# ******************************
data "aws_ssm_parameter" "amzn_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

}

resource "aws_instance" "main" {
  ami                    = data.aws_ssm_parameter.amzn_ami.value
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.main.name

  # EBSのルートボリューム設定
  root_block_device {
    # ボリュームサイズ(GiB)
    volume_size = 8
    # ボリュームタイプ
    volume_type = "gp3"
    # EBSのNameタグ
    tags = {
      Name = "${var.project}-${var.env}-ebs-test"
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-ec2-test"
  }
}

resource "aws_ssm_association" "main" {
  association_name = "${var.project}-${var.env}-association-test"
  name             = "AWS-RunShellScript"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.main.id]
  }

  parameters = {
    "commands" = <<EOF
sudo yum install -y stress
EOF
  }
}

# ******************************
# IAM Role
# ******************************
resource "aws_iam_role" "main" {
  name = "${var.project}-${var.env}-role-ec2-test"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  path = "/"
}

resource "aws_iam_policy_attachment" "main" {
  name       = "${var.project}-${var.env}-policy-attachment-ec2-test"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.main.name]

}

# ******************************
# IAM InstanceProfile
# ******************************
resource "aws_iam_instance_profile" "main" {
  name = "${var.project}-${var.env}-instance-profile"

  role = aws_iam_role.main.name
}
