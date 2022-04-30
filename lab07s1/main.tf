module "resource_group" {
  source   = "./modules/resource_group"
  rg2      = "6507-Ansible-RG"
  location = "Canada East"
}


module "network" {
  source     = "./modules/network"
  rg2        = module.resource_group.rg2.name
  location   = module.resource_group.rg2.location
  vnet       = "vnet-prd"
  vnet_space = ["10.0.0.0/16"]
  # subnet1       = "subnet-prd"
  # subnet_space1 = ["10.0.0.0/24"]
  # nsg1          = "nsg-prd"
  subnet2       = "subnet-prd2"
  subnet_space2 = ["10.0.1.0/24"]
  nsg2          = "nsg-prd2"
  depends_on    = [module.resource_group]


}



module "linux" {
  source = "./modules/linux"
  # linux_name =  "linux-centos-vm"
  linux_name = { ansible-c07-vm1 = "Standard_B1s"
  ansible-c07-vm2 = "Standard_B1s" }
  linux_avs = "linux-avs"
  linux_rg2 = module.resource_group.rg2.name
  location  = module.resource_group.rg2.location
  subnet    = module.network.subnet2_id
  # nsg =       module.network.nsg1
  depends_on = [module.network]


}


module "windows" {
  source      = "./modules/windows"
  windows_avs = "windows-avs"
  windows_name = {
    ansible-w07-vm1 = "Standard_B1s"
    # terrafrom-w-vm2 = "Standard_B1ms"
  }
  win_rg2    = module.resource_group.rg2.name
  location   = module.resource_group.rg2.location
  subnet2    = module.network.subnet2_id
  depends_on = [module.network]

}





