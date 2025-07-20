pipeline {
  agent any

  parameters {
     choice(
    name: 'ENV',
    choices: ['staging', 'production'],
    description: 'Which environment to deploy'
  )
    }
    // 0. Choose the environment to deploy
    //    This will create a new Terraform workspace for the chosen ENV
    //    and use a state file named after ENV (e.g., staging.terraform.tfstate)

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
    TF_VAR_location        = 'canadacentral' 
    TF_VAR_admin_password = credentials('azure-vm-admin-password')          // or pull from a credential/string if you like
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
        bat """
  REM select or create the workspace for the chosen ENV
  terraform workspace select %ENV% || terraform workspace new %ENV%
  REM initialize backend to use a state file named after ENV
  terraform init ^
    -backend-config="key=%ENV%.terraform.tfstate" ^
    -reconfigure -upgrade -input=false
  terraform validate -no-color
"""
      }
    }

    stage('Plan') {
      steps {
        // Plan non-interactively
        bat """
  terraform plan ^
    -input=false ^
    -var-file="%ENV%.tfvars" ^
    -out=plan.tfplan
"""
      }
      post {
        always {
          archiveArtifacts artifacts: 'plan.tfplan'
        }
      }
    }

    stage('Apply') {
      
      steps {
        // Safe re‑init (no -upgrade) then apply plan
        bat """
  terraform workspace select %ENV%
  terraform init -input=false
  terraform apply -input=false -auto-approve plan.tfplan
"""
      }
    }
  }
}
