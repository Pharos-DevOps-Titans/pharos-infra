output "demo_bucket" { value = aws_s3_bucket.logs.id }
output "demo_security_group" { value = aws_security_group.demo.id }
