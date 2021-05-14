[
    {
      "portMappings": [
        {
          "hostPort": 4000,
          "containerPort": 4000
        }
      ],
      "memoryReservation": 256,
      "essential": true,
      "dependsOn": [
        {
          "containerName": "sites-migrations",
          "condition": "COMPLETE"
        }
      ],
      "environment": [
        {
          "name": "POSTGRES_DB",
          "value": "${postgres_db}"
        },
        {
          "name": "SECRET_KEY_BASE",
          "value": "${secret_key_base}"
        },
        {
          "value": "${app_host}",
          "name": "HOST"
        },
        {
          "value": "${postgres_host}",
          "name": "POSTGRES_HOST"
        },
        {
          "value": "${postgres_password}",
          "name": "POSTGRES_PASSWORD"
        },
        {
          "value": "${postgres_user}",
          "name": "POSTGRES_USER"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${log_group_name}",
            "awslogs-region": "${log_group_region}",
            "awslogs-stream-prefix": "api"
          }
      },
      "image": "${app_image}",
      "name": "sites-container-develop"
    },
    {
      "command": [
        "bin/demo",
        "eval",
        "Demo.Release.setup"
      ],
      "memoryReservation": 256,
      "essential": false,
      "environment": [
        {
          "name": "POSTGRES_DB",
          "value": "${postgres_db}"
        },
        {
          "name": "SECRET_KEY_BASE",
          "value": "${secret_key_base}"
        },
        {
          "value": "${app_host}",
          "name": "HOST"
        },
        {
          "value": "${postgres_host}",
          "name": "POSTGRES_HOST"
        },
        {
          "value": "${postgres_password}",
          "name": "POSTGRES_PASSWORD"
        },
        {
          "value": "${postgres_user}",
          "name": "POSTGRES_USER"
        }
      ],
      "image": "${app_image}",
      "name": "sites-migrations"
    }
  ]