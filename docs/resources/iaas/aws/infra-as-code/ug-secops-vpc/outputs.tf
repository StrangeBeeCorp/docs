output "bastion-host_public_ip" {
  value = aws_eip.bastion-host-secops-eip.public_ip
}

output "nat-gw_public_ip" {
  value = aws_eip.secops-nat-gw-eip.public_ip
}
