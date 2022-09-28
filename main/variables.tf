variable "location_code" {
  description = "The short code of location to target."
  type = string
  default     = "eu"
}

variable "terraform_remote_state_access_key" {
  description = "Storage account access key for remote state."
  type = string
  default = ""
  sensitive = true
}