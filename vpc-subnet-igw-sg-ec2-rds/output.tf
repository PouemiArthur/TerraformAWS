output "vpc_id" {
  value = aws_vpc.rdsvpc.id
}


output "ec2_security_group" {
  value = aws_security_group.ec2sg.id
}

output "ec2_instance_id" {
  value = aws_instance.pjrec2.id
}

output "rds_instance_id" {
  value = aws_db_instance.pjrrds.id
}
