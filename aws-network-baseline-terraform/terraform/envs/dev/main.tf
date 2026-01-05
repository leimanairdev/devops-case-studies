module "network" {
  source = "../../modules/network"

  name                = "${var.name}-${var.env}"
  vpc_cidr            = var.vpc_cidr
  az_count            = var.az_count
  public_subnet_bits  = 4
  private_subnet_bits = 4
}
