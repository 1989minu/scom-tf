module "step_function"{

  source = "./Modules/step-function"
  
}

module "lambda"{

  source = "./Modules/lambda"
  sfn_state_machine_arn = module.step_function.sfn_state_machine_arn

}

module "S3"{

  source = "./Modules/S3"
  lambda_func_arn = module.lambda.lambda_func_arn
  bucket_name = var.bucket_name
}

module "dynamodb"{

  source = "./Modules/Dynamodb"
  Table_name = var.Table_name
  key_name = var.key_name
}

