#!groovy
build('swag-v2', 'docker-host') {
    checkoutRepo()
    loadBuildUtils()

    def pipeDefault
    def gitUtils
    runStage('load pipeline') {
        env.JENKINS_LIB = "build_utils/jenkins_lib"
        pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
        gitUtils = load("${env.JENKINS_LIB}/gitUtils.groovy")
    }

    pipeDefault() {
        runStage('init') {
            withGithubSshCredentials {
                sh 'make wc_init'
            }
        }

        runStage('build') {
            sh 'make wc_build'
        }

        // Java
        runStage('Build client & server') {
            withCredentials([[$class: 'FileBinding', credentialsId: 'java-maven-settings.xml', variable: 'SETTINGS_XML']]) {
                if (env.BRANCH_NAME == 'v2' || env.BRANCH_NAME.startsWith('epic/')) {
                    sh 'make SETTINGS_XML=${SETTINGS_XML} BRANCH_NAME=${BRANCH_NAME} java.swag.deploy_client'
                    sh 'make SETTINGS_XML=${SETTINGS_XML} BRANCH_NAME=${BRANCH_NAME} java.swag.deploy_server'
                } else {
                    sh 'make SETTINGS_XML=${SETTINGS_XML} BRANCH_NAME=${BRANCH_NAME} java.swag.compile_client'
                    sh 'make SETTINGS_XML=${SETTINGS_XML} BRANCH_NAME=${BRANCH_NAME} java.swag.compile_server'
                }
            }
        }
    }
}
