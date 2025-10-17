resource "aws_apprunner_service" "webapp" {
  service_name = "ri-academy-of-wine-webapp"

  source_configuration {
    auto_deployments_enabled = true

    code_repository {
      repository_url = var.github_repository_url

      source_code_version {
        type  = "BRANCH"
        value = var.github_branch
      }

      code_configuration {
        configuration_source = "REPOSITORY"
      }

      source_directory = "webapp"
    }

    authentication_configuration {
      connection_arn = var.github_connection_arn
    }
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_instance_role.arn
    cpu               = var.cpu
    memory            = var.memory
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 3
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.webapp.arn

  tags = {
    Name = "ri-academy-of-wine-webapp"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "webapp" {
  auto_scaling_configuration_name = "webapp-autoscaling"

  max_concurrency = var.max_concurrency
  max_size        = var.max_size
  min_size        = var.min_size

  tags = {
    Name = "ri-academy-of-wine-webapp-autoscaling"
  }
}
