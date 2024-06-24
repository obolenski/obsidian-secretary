resource "aws_iam_role" "obsidian_secretary_role" {
  name               = "obsidian_secretary_role"
  tags               = local.tags
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "obsidian_secretary_role_policy" {
  name        = "obsidian_secretary_role_policy"
  description = "Policy for obsidianbot Lambda function"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.obsidian_secretary_role.name
  policy_arn = aws_iam_policy.obsidian_secretary_role_policy.arn
}
