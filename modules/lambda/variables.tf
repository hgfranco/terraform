variable "lambda_function_filename" {
  description = "Path to the function's deployment package within the local filesystem"
}

variable "lambda_function_function_name" {
  description = "Unique name for your Lambda Function"
}

variable "lambda_function_role" {
  description = "Amazon Resource Name (ARN) of the function's execution role"
}

variable "lambda_function_handler" {
  description = "Function entrypoint in your code"
}

variable "lambda_function_memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
}

variable "lambda_function_timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
}

variable "lambda_function_runtime" {
  description = "Identifier of the function's runtime"
}

variable "lambda_function_package_type" {
  description = "Lambda deployment package type"
}

variable "lambda_function_tracing_config_mode" {
  description = "Whether to to sample and trace a subset of incoming requests with AWS X-Ray"
}

variable "lambda_function_ephemeral_storage_size" {
  description = "The amount of Ephemeral storage"
}

variable "lambda_function_fontconfig_path" {
  description = "Map of environment variables that are accessible from the function code during execution"
}

variable "lambda_function_golden_gate_pdf_secret" {
  description = "Map of environment variables that are accessible from the function code during execution"
}

variable "lambda_function_layer_1" {
  description = "List of Lambda Layer Version ARNs"
}

variable "lambda_function_layer_2" {
  description = "List of Lambda Layer Version ARNs"
}

variable "lambda_permission_source_arn" {
  description = "When the principal is an AWS service, the ARN of the specific resource within that service to grant permission to"
}

variable "lambda_permission_action" {
  description = "The AWS Lambda action you want to allow in this statement."
}

variable "lambda_permission_principal" {
  description = "The principal who is getting this permission "
}
