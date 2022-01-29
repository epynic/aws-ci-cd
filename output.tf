output "jump_box_eip" {
  value = aws_eip.prod_public_eip.*.public_ip
}