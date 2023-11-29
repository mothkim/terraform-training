resource "aws_subnet" "my_subnet_specific" {
  vpc_id     = "vpc-0894036724877c60f"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "my_subnet_specific"
  }
}