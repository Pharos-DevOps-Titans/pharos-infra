# IMPORTANT: Replace the cidr_blocks in the allowed_rdp_cidrs local with your organization's
# specific trusted IP ranges (e.g., corporate VPN CIDR, bastion host IP, office egress IPs).
# DO NOT leave 0.0.0.0/0 in the replacement rule. If RDP must be allowed, use a VPN or
# AWS Systems Manager Session Manager instead of direct RDP exposure.

locals {
  # REPLACE THESE with your actual trusted CIDR ranges
  # Examples: corporate VPN, office IP, bastion host
  allowed_rdp_cidrs = [
    "10.0.0.0/8",       # Internal VPC/private network range (adjust to your VPC CIDR)
    # "203.0.113.50/32" # Example: specific office/VPN egress IP (uncomment and set real IP)
  ]
}

resource "aws_security_group" "cybertalents_production_powerbi_sg" {
  name        = "cybertalents-production-powerbi-sg"
  description = "Security group for PowerBI production instance - RDP restricted to trusted IPs only"
  vpc_id      = "vpc-00d3e684759e4bfc6"

  # RDP access restricted to trusted CIDRs only - NO public internet access
  ingress {
    description = "RDP from trusted internal/VPN IPs only"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = local.allowed_rdp_cidrs
  }

  # Preserve any existing legitimate egress rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name               = "cybertalents-production-powerbi-sg"
    OriginalName       = "powerbi"
    Project            = "DisasterRecovery"
    Environment        = "production"
    ManagedBy          = "Terraform"
    MigratedFrom       = "015061128280"
    OriginalInstanceId = "i-01646fd2cd65e450f"
    RemediatedOn       = "2025-01-01"
    RemediationReason  = "CriticalSecurity-RDPPublicExposure"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# RECOMMENDED ALTERNATIVE: Use AWS Systems Manager Session Manager for remote access
# This eliminates the need for RDP/port 3389 entirely
# resource "aws_iam_role_policy_attachment" "ssm_policy" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }