variable "email_subscriber" {
  description = "Email subscriber for SNS topic"
  type        = string
  default     = "pcooke2002@yahoo.com"
}

variable "api_key" {
  description = "API key for API Gateway"
  type        = string
  default     = "MBmlslh7mf6PIojvCjyRo1Sznd6ZXOZI9Lw4RyT7"
}

variable "stage_default" {
  description = "Default stage name for API Gateway"
  type        = string
  default     = "default"
}

variable "stage_poc" {
  description = "POC stage name for API Gateway"
  type        = string
  default     = "poc"
}
