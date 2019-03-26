# Declaring variables for terraform configuration
variable "ARM_CLIENT_ID" {}

variable "ARM_CLIENT_SECRET" {}

variable "ARM_SUBSCRIPTION_ID" {}

variable "ARM_TENANT_ID" {}

# Declare env variable
variable "env" {}

variable "location" {}
# Declare storage account details
variable "sto_acc_tier_std" {}
variable "sto_acc_rep_type_lrs" {}

# Declare Host basename
variable "ax_base_hostname" {}

variable "sql_base_hostname" {}
variable "web_base_hostname" {}
variable "app_base_hostname" {}

variable "fs_base_hostname" {}
# Declare VM details

variable "win_image_publisher" {}

variable "sql_image_publisher" {}

variable "win_image_offer" {}

variable "sql_image_offer" {}

variable "win_2012_sku" {}

variable "win_2016_sku" {}

variable "sql_sku" {}

variable "image_version" {}

variable "sql_image_version" {}

variable "AX_VM_SIZE" {}

variable "SQL_VM_SIZE" {}

variable "web_vm_size" {}
variable "fs_vm_size" {}
variable "ax_nsg" {}

variable "sql_nsg" {}
variable "web_nsg" {}

variable "username" {}

variable "password" {}
variable "caching_option" {}
variable "create_option" {}
variable "managed_disk_std_lrs" {} 
variable "managed_disk_prem_lrs" {}
variable "ax_avset" {}
variable "sql_avset" {}

# variable "department" {}

# variable "cost_centre" {}

# variable "product_owner" {}

# variable "product_manager" {}

# variable "portfolio_manager" {}

# variable "product_name" {}

# variable "managed_by" {}
# End of declaring variables

# Declaring various resources
###################################################################################################
#                   Standard for Declaring Terraform Internal Variables
###################################################################################################
# tf-{abbreviated resource type}-{Environment Name}
# rg   - Resource Group
# vn   - Virtual Network
# sn   - Subnet
# ni   - Network Interface
# sa   - Storage Account
# vm   - Virtual Machine
# mdsk - Managed Disk
# as   - Availability Set
# pubip - Public IP

###################################################################################################
#
###################################################################################################

# Resource Group
# resource "azurerm_resource_group" "tf-rg-cluster-aos" {
#   name     = "rg-app"
#   location = "${var.location}"

# tags {
#   environment        = "${var.env}"
#   # department         = "${var.department}" 
#   # cost_centre        = "${var.cost_centre}"
#   # product_owner      = "${var.product_owner}"
#   # product_manager    = "${var.product_manager}"
#   # portfolio_manager  = "${var.portfolio_manager}"
#   # product_name       = "${var.product_name}"
#   # managed_by         = "${var.managed_by}"   
#      }  
# }

# Reference existing resource group for Virtual Network
# data "azurerm_resource_group" "tf-rg-cluster-external" {
#   name = "rg_vnets"
# }

# # Reference existing Virtual Network
# data "azurerm_virtual_network" "tf-vn-cluster" {
#   name                 = "vnet_frednxt_groups_preprod"
#   resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
# }

# # Reference existing subnet

# data "azurerm_subnet" "tf-sn-cluster-aos" {
#   name                 = "subnet_app"
#   virtual_network_name = "${data.azurerm_virtual_network.tf-vn-cluster.name}"
#   resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
# }

# data "azurerm_subnet" "tf-sn-cluster-web" {
#   name                 = "subnet_app"
#   virtual_network_name = "${data.azurerm_virtual_network.tf-vn-cluster.name}"
#   resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
# }
# data "azurerm_subnet" "tf-sn-cluster-app" {
#   name                 = "subnet_remote"
#   virtual_network_name = "${data.azurerm_virtual_network.tf-vn-cluster.name}"
#   resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
# }
# data "azurerm_subnet" "tf-sn-cluster-sql" {
#   name                 = "subnet_sql"
#   virtual_network_name = "${data.azurerm_virtual_network.tf-vn-cluster.name}"
#   resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
# }

# data "azurerm_subnet" "tf-sn-cluster-fs" {
#   name                 = "subnet_sql"
#   virtual_network_name = "${data.azurerm_virtual_network.tf-vn-cluster.name}"
#   resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
# }
# resource "azurerm_public_ip" "tf-pubip-cluster-aos" {
#     count                        = 5
#     name                         = "${var.ax_base_hostname}-${count.index+1}-PUBIP"
#     location                     = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
#     resource_group_name          = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
#     allocation_method            = "Dynamic"

#     tags {
#          environment        = "${var.env}"
# # department         = "${var.department}" 
# # cost_centre        = "${var.cost_centre}"
# # product_owner      = "${var.product_owner}"
# # product_manager    = "${var.product_manager}"
# # portfolio_manager  = "${var.portfolio_manager}"
# # product_name       = "${var.product_name}"
# # managed_by         = "${var.managed_by}"  
#     }
# }
# # Network Interface for AOS
# resource "azurerm_network_interface" "tf-ni-cluster-aos" {
#  count               = 5
#  name                = "${var.ax_base_hostname}-${count.index+1}-NI"
#  location            = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
#  resource_group_name = "${azurerm_resource_group.tf-rg-cluster-aos.name}"

# ip_configuration {
#     name                          = "${var.ax_base_hostname}-${count.index+1}-IP"
#     subnet_id                     = "${data.azurerm_subnet.tf-sn-cluster-aos.id}"
#     #private_ip_address_allocation = "static"
#     private_ip_address_allocation = "Dynamic"
#     #private_ip_address            ="10.100.1.${count.index+5}"
#     public_ip_address_id          = "${element(azurerm_public_ip.tf-pubip-cluster-aos.*.id, count.index)}"
#     # Remove public ip when it is not required
# }
# tags {
#     environment        = "${var.env}"
#   # department         = "${var.department}" 
#   # cost_centre        = "${var.cost_centre}"
#   # product_owner      = "${var.product_owner}"
#   # product_manager    = "${var.product_manager}"
#   # portfolio_manager  = "${var.portfolio_manager}"
#   # product_name       = "${var.product_name}"
#   # managed_by         = "${var.managed_by}"  
#      }  
# }
# resource "azurerm_network_security_group" "tf-nsg-cluster-aos" {
#   name                = "${var.ax_nsg}"
#   location            = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
#   resource_group_name = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
# }
# resource "azurerm_network_security_rule" "tf-nsr-cluster-aos" {
#   name                        = "Rule01"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
#   network_security_group_name = "${azurerm_network_security_group.tf-nsg-cluster-aos.name}"
# }
# # Storage Account
# resource "azurerm_storage_account" "tf-sa-cluster-aos" {
#   count                    = 5
#   name                     = "${lower(var.ax_base_hostname)}${count.index+1}stoacc"
#   location                 = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
#   resource_group_name      = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
#   account_tier             = "${var.sto_acc_tier_std}"
#   account_replication_type = "${var.sto_acc_rep_type_lrs}"

# tags {
#     environment        = "${var.env}"
#   # department         = "${var.department}" 
#   # cost_centre        = "${var.cost_centre}"
#   # product_owner      = "${var.product_owner}"
#   # product_manager    = "${var.product_manager}"
#   # portfolio_manager  = "${var.portfolio_manager}"
#   # product_name       = "${var.product_name}"
#   # managed_by         = "${var.managed_by}"  
#      }  
# }

# # Optional Managed Data Disk
# # resource "azurerm_managed_disk" "tf-mdsk-cluster" {
# #   count                = 5
# #   name                 = "${var.ax_base_hostname}-${count.index+1}-DATADISK-1"
# #   location             = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
# #   resource_group_name  = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
# #   storage_account_type = "${var.managed_disk_std_lrs}"
# #   create_option        = "Empty"
# #   disk_size_gb         = "1024"
# # }

# # resource "azurerm_managed_disk" "tf-mdsk-2-cluster" {
# #       count                = 5
# #       name                 = "${var.ax_base_hostname}-${count.index+1}-DATADISK-2"
# #       location             = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
# #       resource_group_name  = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
# #       storage_account_type = "${var.managed_disk_std_lrs}"
# #       create_option        = "Empty"
# #       disk_size_gb         = "1024"
# #     }
# # Availability Set
# resource "azurerm_availability_set" "tf-as-cluster-aos" {
#   name                         = "${var.ax_avset}"
#   location                     = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
#   resource_group_name          = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
#   platform_fault_domain_count  = 2
#   platform_update_domain_count = 2
#   managed                      = true

# tags {
#     environment        = "${var.env}"
#   # department         = "${var.department}" 
#   # cost_centre        = "${var.cost_centre}"
#   # product_owner      = "${var.product_owner}"
#   # product_manager    = "${var.product_manager}"
#   # portfolio_manager  = "${var.portfolio_manager}"
#   # product_name       = "${var.product_name}"
#   # managed_by         = "${var.managed_by}"  
#      }  
# }

# # module "vm-creation" {
# #   source  = "modules/vm-creation"
# # }

# resource "azurerm_virtual_machine" "tf-vm-cluster-aos" {
#   count                 = 5
#   name                  = "${var.ax_base_hostname}-${count.index+1}"
#   location            = "${azurerm_resource_group.tf-rg-cluster-aos.location}"
#   resource_group_name = "${azurerm_resource_group.tf-rg-cluster-aos.name}"
#   availability_set_id   = "${azurerm_availability_set.tf-as-cluster-aos.id}"
#   network_interface_ids = ["${element(azurerm_network_interface.tf-ni-cluster-aos.*.id, count.index)}"]
#   vm_size               = "${var.AX_VM_SIZE}"


# delete_os_disk_on_termination = true

# delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "${var.win_image_publisher}"
#     offer     = "${var.win_image_offer}"
#     sku       = "${var.win_2012_sku}"
#     version   = "${var.image_version}"
#   }

#   storage_os_disk {
#     name              = "${var.ax_base_hostname}-${count.index+1}-OS-DISK"
#     caching           = "${var.caching_option}"
#     create_option     = "${var.create_option}"
#     managed_disk_type = "${var.managed_disk_std_lrs}"
#   }

# os_profile {
#   computer_name  = "${var.ax_base_hostname}-${count.index+1}"
#   admin_username = "${var.username}"
#   admin_password = "${var.password}"

# }
# os_profile_windows_config {
#       provision_vm_agent = "true"
#       enable_automatic_upgrades = "true"
#       winrm {
#         protocol = "HTTP"
#       }
#   }

# tags {
#     environment        = "${var.env}"
#   # department         = "${var.department}" 
#   # cost_centre        = "${var.cost_centre}"
#   # product_owner      = "${var.product_owner}"
#   # product_manager    = "${var.product_manager}"
#   # portfolio_manager  = "${var.portfolio_manager}"
#   # product_name       = "${var.product_name}"
#   # managed_by         = "${var.managed_by}"  
# }
# }
