variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}


###########
# Function
###########

variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "region" {
  description = "Region of  aws AZ"
  type        = string
}

variable "role_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
}

variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}


variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}


variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

