output "vpc" {
  value = element("${aws_vpc.dedicated-vpc.*}",0)
}
output "public_subnet" {
  value = element("${aws_subnet.dedicated-subnet.*}",0)
}
output "igw" {
  value = element("${aws_internet_gateway.dedicated-igw.*}",0)
}
output "route_table" {
  value = element("${aws_route_table.dedicated-public-rt.*}",0)
}
output "ami" {
  value = element("${data.aws_ami.custom_ami.*}",0)
}
# output "availability_zone" {
#   value = "${}"
# }
output "instance" {
  value = "${aws_instance.vpn_access_server.*}"
}
output "eip" {
  value = "${aws_eip.vpn_access_server.*}"
}
output "region" {
  value = "${data.aws_region.current}"
}
# output "tags" {
#   value = "${}"
# }