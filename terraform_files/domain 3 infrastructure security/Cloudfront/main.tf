provider "aws" {
  region = "eu-central-1" # Adjust the region as needed
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-image-bucket" # Replace with your desired bucket name

  tags = {
    Name = "my-image-bucket"
  }
}

resource "aws_s3_bucket_object" "image1" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "image1.jpg" # Replace with your image file name
  source = "path/to/image1.jpg" # Replace with the path to your image file
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "image2" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "image2.jpg" # Replace with your image file name
  source = "path/to/image2.jpg" # Replace with the path to your image file
  acl    = "public-read"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for my S3 bucket"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path}"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = aws_s3_bucket.my_bucket.bucket_regional_domain_name
    origin_id   = "S3-my-image-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for my S3 bucket"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-my-image-bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "my-cloudfront-distribution"
  }
}