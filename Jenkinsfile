pipeline {
  agent any
  stages {
    stage('Deploy back') {
      steps {
        ansiblePlaybook '/var/lib/jenkins/playbooks/backinter.yml'
      }
    }

  }
}