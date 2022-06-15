resource "aws_lambda_function" "create_lambda" {
  filename         = var.lambda_function_filename
  function_name    = var.lambda_function_function_name
  role             = var.lambda_function_role
  handler          = var.lambda_function_handler
  source_code_hash = filebase64sha256(var.lambda_function_filename)
  memory_size      = var.lambda_function_memory_size
  timeout          = var.lambda_function_timeout
  runtime          = var.lambda_function_runtime
  package_type     = var.lambda_function_package_type

  tracing_config {
    mode = var.lambda_function_tracing_config_mode
  }

  ephemeral_storage {
    size = var.lambda_function_ephemeral_storage_size
  }

  environment {
    variables = {
      FONTCONFIG_PATH        = var.lambda_function_fontconfig_path,
      GOLDEN_GATE_PDF_SECRET = var.lambda_function_golden_gate_pdf_secret
    }
  }

  layers = [
    var.lambda_function_layer_1,
    var.lambda_function_layer_2
  ]
}

resource "aws_lambda_permission" "create_lambda_permission" {
  function_name = aws_lambda_function.create_lambda.arn
  source_arn    = "${var.lambda_permission_source_arn}/*/*/html_to_pdf"

  action    = var.lambda_permission_action
  principal = var.lambda_permission_principal
}
