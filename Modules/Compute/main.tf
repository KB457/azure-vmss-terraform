resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                = var.vmss_name
  resource_group_name = var.resource_group_name              
  location            = var.location              
  sku                 = var.sku_size
  instances           = var.vmss_instances
  zones = var.vmss_zones
  admin_username      = var.admin_name

  admin_ssh_key {
    username   = var.admin_name
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name                                   = "${var.vmss_name}-name"
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.backend_address_pool_id]
      primary                                = true
    }
     
  }


    custom_data = base64encode(<<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2
    sudo ufw allow 80/tcp
    echo "Hello! Your Test VM is working!" | sudo tee /var/www/html/index.html
    sudo systemctl restart apache2
    EOF

  )
   tags = {
    environment = "test"}
}
resource "azurerm_virtual_machine_scale_set_extension" "install_apache" {
  name                           = "install-apache"
  virtual_machine_scale_set_id   = azurerm_linux_virtual_machine_scale_set.main.id
  publisher                      = "Microsoft.Azure.Extensions"
  type                           = "CustomScript"
  type_handler_version           = "2.1"
  auto_upgrade_minor_version     = true

  protected_settings = jsonencode({
    commandToExecute = "bash -c \"set -eux; export DEBIAN_FRONTEND=noninteractive; apt-get update -y; apt-get install -y apache2; systemctl enable apache2; systemctl restart apache2; echo 'Hello KB from $(hostname)' > /var/www/html/index.html\""
  })
}


resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "vmss-autoscale"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.main.id

  enabled = true

  profile {
    name = "AutoScaleProfile"
    capacity {
      minimum = "2"
      maximum = "5"
      default = "3"
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
