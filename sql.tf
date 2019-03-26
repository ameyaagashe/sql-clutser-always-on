# Resource Group
data "azurerm_resource_group" "tf-rg-cluster-external" {
  name = "rg-cluster"
}
data "azurerm_virtual_network" "tf-vn-cluster" {
  name                 = "mainnetynjaqceg"
  resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
}
# Reference existing subnet
data "azurerm_subnet" "tf-sn-cluster-sql" {
  name                 = "subnet-sql"
  virtual_network_name = "${data.azurerm_virtual_network.tf-vn-cluster.name}"
  resource_group_name  = "${data.azurerm_resource_group.tf-rg-cluster-external.name}"
}

resource "azurerm_resource_group" "tf-rg-cluster-sql" {
  name     = "rg-sql"
  location = "${var.location}"

tags {
    environment        = "${var.env}"
  # department         = "${var.department}" 
  # cost_centre        = "${var.cost_centre}"
  # product_owner      = "${var.product_owner}"
  # product_manager    = "${var.product_manager}"
  # portfolio_manager  = "${var.portfolio_manager}"
  # product_name       = "${var.product_name}"
  # managed_by         = "${var.managed_by}"  
     }  
}
# resource "azurerm_virtual_network" "tf-vn-cluster-sql" {
#     name                = "ameya-vn"
#     address_space       = ["10.0.0.0/16"]
#     location            = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
#     resource_group_name = "${azurerm_resource_group.tf-rg-cluster-sql.name}"

#     tags {
#         environment = "${var.env}"
#     }
# }
# resource "azurerm_subnet" "tf-sn-cluster-sql" {
#     name                 = "ameya-sn"
#     resource_group_name  = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
#     virtual_network_name = "${azurerm_virtual_network.tf-vn-cluster-sql.name}"
#     address_prefix       = "10.0.2.0/24"
# }

resource "azurerm_public_ip" "tf-pubip-cluster-sql" {
    count                        = 4
    name                         = "${var.sql_base_hostname}-${count.index+1}-PUBIP"
    location                     = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
    resource_group_name          = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
    allocation_method            = "Dynamic"

    tags {
          environment        = "${var.env}"
  # department         = "${var.department}" 
  # cost_centre        = "${var.cost_centre}"
  # product_owner      = "${var.product_owner}"
  # product_manager    = "${var.product_manager}"
  # portfolio_manager  = "${var.portfolio_manager}"
  # product_name       = "${var.product_name}"
  # managed_by         = "${var.managed_by}"  
    }
}
# Network Interface for SQL
resource "azurerm_network_interface" "tf-ni-cluster-sql" {
 count               = 4
 name                = "${var.sql_base_hostname}-${count.index+1}-NI"
 location            = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
 resource_group_name = "${azurerm_resource_group.tf-rg-cluster-sql.name}"

ip_configuration {
    name                          = "${var.sql_base_hostname}-${count.index+1}-IP"
    subnet_id                     = "${data.azurerm_subnet.tf-sn-cluster-sql.id}"
    # private_ip_address_allocation = "static"
    # private_ip_address            ="10.100.2.${count.index+5}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.tf-pubip-cluster-sql.*.id, count.index)}"
}
tags {
    environment        = "${var.env}"
  # department         = "${var.department}" 
  # cost_centre        = "${var.cost_centre}"
  # product_owner      = "${var.product_owner}"
  # product_manager    = "${var.product_manager}"
  # portfolio_manager  = "${var.portfolio_manager}"
  # product_name       = "${var.product_name}"
  # managed_by         = "${var.managed_by}"  
     }  
}
resource "azurerm_network_security_group" "tf-nsg-cluster-sql" {
  name                = "${var.sql_nsg}"
  location            = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
  resource_group_name = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
}
resource "azurerm_network_security_rule" "tf-nsr-cluster-sql" {
  name                        = "Rule01"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
  network_security_group_name = "${azurerm_network_security_group.tf-nsg-cluster-sql.name}"
}
# Storage Account
resource "azurerm_storage_account" "tf-sa-cluster-sql" {
  count                    = 4
  name                     = "${lower(var.sql_base_hostname)}${count.index+1}stoacc"
  location                 = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
  resource_group_name      = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
  account_tier             = "${var.sto_acc_tier_std}"
  account_replication_type = "${var.sto_acc_rep_type_lrs}"

tags {
   environment        = "${var.env}"
  # department         = "${var.department}" 
  # cost_centre        = "${var.cost_centre}"
  # product_owner      = "${var.product_owner}"
  # product_manager    = "${var.product_manager}"
  # portfolio_manager  = "${var.portfolio_manager}"
  # product_name       = "${var.product_name}"
  # managed_by         = "${var.managed_by}"  
     }  
}

# Managed Data Disk
# resource "azurerm_managed_disk" "tf-mdsk-1-cluster-sql" {
#   count                = 2
#   name                 = "${var.ax_base_hostname}-${count.index+1}-DATADISK-1"
#   location             = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
#   resource_group_name  = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
#   storage_account_type = "${var.managed_disk_prem_lrs}"
#   create_option        = "Empty"
#   disk_size_gb         = "1024"
# }

# resource "azurerm_managed_disk" "tf-mdsk-2-cluster-sql" {
#       count                = 2
#       name                 = "${var.ax_base_hostname}-${count.index+1}-DATADISK-2"
#       location             = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
#       resource_group_name  = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
#       storage_account_type = "${var.managed_disk_prem_lrs}"
#       create_option        = "Empty"
#       disk_size_gb         = "1024"
#     }
# resource "azurerm_managed_disk" "tf-mdsk-3-cluster-sql" {
#       count                = 2
#       name                 = "${var.ax_base_hostname}-${count.index+1}-DATADISK-3"
#       location             = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
#       resource_group_name  = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
#       storage_account_type = "${var.managed_disk_prem_lrs}"
#       create_option        = "Empty"
#       disk_size_gb         = "1024"
#     }

# resource "azurerm_managed_disk" "tf-mdsk-4-cluster-sql" {
#       count                = 2
#       name                 = "${var.ax_base_hostname}-${count.index+1}-DATADISK-4"
#       location             = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
#       resource_group_name  = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
#       storage_account_type = "${var.managed_disk_prem_lrs}"
#       create_option        = "Empty"
#       disk_size_gb         = "1024"
#     }


# Availability Set
resource "azurerm_availability_set" "tf-as-cluster-sql" {
  name                         = "${var.sql_avset}"
  location                     = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
  resource_group_name          = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 3
  managed                      = true

tags {
   environment        = "${var.env}"
  # department         = "${var.department}" 
  # cost_centre        = "${var.cost_centre}"
  # product_owner      = "${var.product_owner}"
  # product_manager    = "${var.product_manager}"
  # portfolio_manager  = "${var.portfolio_manager}"
  # product_name       = "${var.product_name}"
  # managed_by         = "${var.managed_by}"  
     }  
}

resource "azurerm_virtual_machine" "tf-vm-cluster-sql" {
  count                 = 4
  name                  = "${var.sql_base_hostname}-${count.index+1}"
  location              = "${azurerm_resource_group.tf-rg-cluster-sql.location}"
  availability_set_id   = "${azurerm_availability_set.tf-as-cluster-sql.id}"
  resource_group_name   = "${azurerm_resource_group.tf-rg-cluster-sql.name}"
  network_interface_ids = ["${element(azurerm_network_interface.tf-ni-cluster-sql.*.id, count.index)}"]
  vm_size               = "${var.SQL_VM_SIZE}"


delete_os_disk_on_termination = true


delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.sql_image_publisher}"
    offer     = "${var.sql_image_offer}"
    sku       = "${var.sql_sku}"
    version   = "${var.sql_image_version}"
  }

  storage_os_disk {
    name              = "${var.sql_base_hostname}-${count.index+1}-OS-DISK"
    caching           = "${var.caching_option}"
    create_option     = "${var.create_option}"
    managed_disk_type = "${var.managed_disk_prem_lrs}"
  }
#  storage_data_disk {
#    name            = "${element(azurerm_managed_disk.tf-mdsk-1-cluster-sql.*.name, count.index)}"
#    managed_disk_id = "${element(azurerm_managed_disk.tf-mdsk-1-cluster-sql.*.id, count.index)}"
#    create_option   = "Attach"
#    lun             = 0
#    disk_size_gb    = "${element(azurerm_managed_disk.tf-mdsk-1-cluster-sql.*.disk_size_gb, count.index)}"
#  }

#  storage_data_disk {
#    name            = "${element(azurerm_managed_disk.tf-mdsk-2-cluster-sql.*.name, count.index)}"
#    managed_disk_id = "${element(azurerm_managed_disk.tf-mdsk-2-cluster-sql.*.id, count.index)}"
#    create_option   = "Attach"
#    lun             = 1
#    disk_size_gb    = "${element(azurerm_managed_disk.tf-mdsk-2-cluster-sql.*.disk_size_gb, count.index)}"
#  }

#   storage_data_disk {
#    name            = "${element(azurerm_managed_disk.tf-mdsk-3-cluster-sql.*.name, count.index)}"
#    managed_disk_id = "${element(azurerm_managed_disk.tf-mdsk-3-cluster-sql.*.id, count.index)}"
#    create_option   = "Attach"
#    lun             = 2
#    disk_size_gb    = "${element(azurerm_managed_disk.tf-mdsk-3-cluster-sql.*.disk_size_gb, count.index)}"
#  }

#   storage_data_disk {
#    name            = "${element(azurerm_managed_disk.tf-mdsk-4-cluster-sql.*.name, count.index)}"
#    managed_disk_id = "${element(azurerm_managed_disk.tf-mdsk-4-cluster-sql.*.id, count.index)}"
#    create_option   = "Attach"
#    lun             = 3
#    disk_size_gb    = "${element(azurerm_managed_disk.tf-mdsk-4-cluster-sql.*.disk_size_gb, count.index)}"
#  }
os_profile {
  computer_name  = "${var.sql_base_hostname}-${count.index+1}"
  admin_username = "${var.username}"
  admin_password = "${var.password}"
  # timezone       = "AUS Eastern Standard Time"
  #winrm { protocol = "HTTP" }
}

os_profile_windows_config {
      provision_vm_agent = "true"
      enable_automatic_upgrades = "true"
      winrm {
        protocol = "HTTP"
      }
  }

tags {
   environment        = "${var.env}"
  # department         = "${var.department}" 
  # cost_centre        = "${var.cost_centre}"
  # product_owner      = "${var.product_owner}"
  # product_manager    = "${var.product_manager}"
  # portfolio_manager  = "${var.portfolio_manager}"
  # product_name       = "${var.product_name}"
  # managed_by         = "${var.managed_by}"  
}
}