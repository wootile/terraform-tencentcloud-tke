### Define the application aws provider

### Define terraform version and required providers
terraform {
  required_version = ">= 1.1.2"
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.67.0"
    }
  }
}
