pipeline {
  agent any
  environment {
    ARM_CLIENT_ID       = credentials('azure-client-id')
    ARM_CLIENT_SECRET   = credentials('azure-client-secret')
    ARM_TENANT_ID       = credentials('azure-tenant-id')
    ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Init & Validate') {
      steps {
        bat 'terraform init -backend-config="key=${env.BRANCH_NAME}.tfstate"'
        bat 'terraform validate'
      }
    }
    stage('Plan') {
      steps {
        bat 'terraform plan -var-file="terraform.tfvars" -out=plan.tfplan'
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
    bat 'terraform init'
    bat 'terraform apply -auto-approve plan.tfplan'
  }
}

  }
}
