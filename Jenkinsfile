pipeline {
  agent any

  // 1. Pull in your SP creds as both AZ and TF_VAR_* vars
  environment {
    // Azure CLI / ARM backend auth
    ARM_CLIENT_ID       = credentials('azure-client-id')
    ARM_CLIENT_SECRET   = credentials('azure-client-secret')
    ARM_TENANT_ID       = credentials('azure-tenant-id')
    ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')

    // Terraform input variables
    TF_VAR_client_id       = credentials('azure-client-id')
    TF_VAR_client_secret   = credentials('azure-client-secret')
    TF_VAR_tenant_id       = credentials('azure-tenant-id')
    TF_VAR_subscription_id = credentials('azure-subscription-id')
    TF_VAR_location        = 'canadacentral'           // or pull from a credential/string if you like
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Azure Login') {
      steps {
        // Authenticate az CLI so Terraform backend can use AAD token
        bat '''
          az login --service-principal ^
            -u %ARM_CLIENT_ID% ^
            -p %ARM_CLIENT_SECRET% ^
            --tenant %ARM_TENANT_ID%
          az account set --subscription %ARM_SUBSCRIPTION_ID%
        '''
      }
    }

    stage('Init & Validate') {
      steps {
        // First time only: reconfigure & upgrade plugins to pick up your required_providers block
        bat '''
          terraform init ^
            -backend-config="resource_group_name=rg-tfstate" ^
            -backend-config="storage_account_name=sttfstate3766" ^
            -backend-config="container_name=tfstate" ^
            -backend-config="key=%BRANCH_NAME%.tfstate" ^
            -reconfigure ^
            -upgrade ^
            -input=false
          terraform validate -no-color
        '''
      }
    }

    stage('Plan') {
      steps {
        // Plan non-interactively
        bat '''
          terraform plan ^
            -input=false ^
            -out=plan.tfplan
        '''
      }
      post {
        always {
          archiveArtifacts artifacts: 'plan.tfplan'
        }
      }
    }

    stage('Apply') {
      when { expression { params.DEPLOY == 'true' } }
      steps {
        // Safe re‑init (no -upgrade) then apply plan
        bat '''
          terraform init -input=false
          terraform apply -input=false -auto-approve plan.tfplan
        '''
      }
    }
  }
}
