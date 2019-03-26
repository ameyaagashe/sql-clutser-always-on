
location="southeastasia"

# Defining ax vms base name
ax_base_hostname="NXTPREPAOS"
sql_base_hostname="NXTPREPSQL"
app_base_hostname="NXTPREPAPP"
web_base_hostname="NXTPREPWEB"
fs_base_hostname="NXTPREPFS"

# VM Details
win_image_publisher="MicrosoftWindowsServer"
sql_image_publisher="MicrosoftSQLServer"
win_image_offer="WindowsServer"
sql_image_offer="sql2014sp3-ws2012r2"
win_2012_sku="2012-R2-Datacenter"
win_2016_sku="2016-Datacenter"
#sql_sku="Enterprise"
sql_sku="sqldev"
image_version="latest"
sql_image_version="12.21.190220"
caching_option="ReadWrite"
create_option="FromImage"
managed_disk_std_lrs="Standard_LRS"
managed_disk_prem_lrs="Premium_LRS"

# ax_addr_prefix="10.100.1.0/24"
# sql_addr_prefix="10.100.2.0/24"

username="scmadmin"
#password="Hash#Dollar$135"
password="HashDollar135"


# Define environment, useful for tagging resources.
env="Visual Studio Enterprise"

# Define Env Details
sto_acc_tier_std="Standard"
sto_acc_rep_type_lrs="LRS"

# Define VM Sizes by Roles
#ax_vm_size="Standard_D3_v2"
# ax_vm_size="Standard_B1s"
# # Original Request for SQL VM's
# sql_vm_size="Standard_B1s"
# sql_vm_size="Standard_E32s_v3"

web_vm_size="Standard_D3_v2"
fs_vm_size="Standard_F4s"

# Define Availabilities Set for Each Role
ax_avset="avail_aos"
sql_avset="avail_sql"

ax_nsg="nsg_subnet_app"
sql_nsg="msg_subnet_sql"
web_nsg="nsg_subnet_web"
variable "web_nsg" {}

