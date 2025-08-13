resource "aws_iam_role" "this" {
  name = "GlueServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

# https://docs.aws.amazon.com/glue/latest/dg/create-service-policy.html
resource "aws_iam_policy" "this" {
  name = "GlueServicePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.raw_bucket.arn,
          "${var.raw_bucket.arn}/*",
          var.processed_bucket.arn,
          "${var.processed_bucket.arn}/*",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*:/aws-glue/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
