# IMPORTANT: Replace the cidr_blocks values below with your organization's
# trusted IP ranges (e.g., corporate VPN CIDR, bastion host IP, or AWS VPN endpoint).
# DO NOT use 0.0.0.0/0 for RDP access. Example trusted CIDRs are placeholders only.

resource "aws_security_group" "cybertalents_production_powerbi_sg" {
  name        = "cybertalents-production-powerbi-sg"
  description = "Security group for PowerBI - RDP restricted to trusted IPs only"
  vpc_id      = "vpc-00d3e684759e4bfc6"

  # REMEDIATION: RDP access restricted to trusted corporate IP ranges only.
  # Replace 203.0.113.0/24 with your actual trusted CIDR(s) — e.g., VPN gateway IP,
  # corporate egress IP, or AWS Client VPN endpoint subnet.
  ingress {
    description = "RDP from trusted corporate network only"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/24"]  # REPLACE with your trusted CIDR range(s)
  }

  # Retain any other existing ingress rules as needed (e.g., HTTPS, custom app ports)
  # Add them here explicitly to avoid Terraform drift.

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
    RemediatedBy       = "FinOps-SecurityRemediation"
    RemediationDate    = "2025-01-01"
  }
}