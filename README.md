**Designed and automated Azure infrastructure (VMSS, Load Balancer, Monitoring) with Terraform using a modular, secure, and scalable approach.**

## 📖 Overview
This project provisions Azure infrastructure using **Terraform**, following best practices for maintainability and scalability.  
The setup includes:
- Resource Group & Networking (VNet, Subnets, NSG, Public IPs)  
- **Virtual Machine Scale Set (VMSS) with SSH access**  
- **Azure Load Balancer** to optimise traffic distribution  
- **Azure Monitor & Log Analytics** for real-time observability and alerts  

## 📂 Project Structure

AZURE-VMSS/
│── main.tf                # Root Terraform configuration
│── variables.tf           # Input variables
│── output.tf              # Outputs
│── Modules/               # Modular approach
│   ├── Network/           # VNet, Subnets, NSG, Public IP
│   ├── Compute/           # VMSS configuration
│   ├── ALB/               # Azure Load Balancer setup
│   ├── Monitoring/        # Log Analytics, Alerts, Metrics
│   └── health/            # Health probe configuration
│
│── .tflint.hcl            # Linting rules (best practices enforcement)
│── README.md              # Project documentation


## ✅ Improvements Made
To bring the code closer to production standards, I:
1. Added **types** to all variables for stricter validation (`string`, `number`, `bool`, `list(string)` etc.).  
2. Configured **TFLint** with the Azure ruleset to automatically catch:  
   - Missing variable types  
   - Invalid or deprecated Azure configurations  
   - Provider/version best practices  
3. Fixed all `tflint` warnings about untyped variables and unused declarations.  
4. Ensured the code is **linted, maintainable, and future-proof**.  

## 🛠️ Tools Used
- **Terraform** (for infrastructure as code)  
- **TFLint** (for linting & best practices)  
- **VS Code** (with Terraform + TFLint extensions)  