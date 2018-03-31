node('docker') {
    def app
    def VERSION=env.VERSION
    def BRANCH=env.BRANCH
    def REPO=env.REPO
    stage('Preparation') { // for display purposes
        if (env.NO_CACHE.toBoolean()) cleanWs()
        checkout scm
        if (! VERSION) VERSION="latest"
        if (! BRANCH) BRANCH="origin/master"
        if (! REPO) REPO='https://github.com/pinry/pinry.git'
        checkout([$class: 'GitSCM', branches: [[name: BRANCH]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'app']], submoduleCfg: [], userRemoteConfigs: [[url: REPO]]])
    }
    stage('Build') {
        def PARAM="."
        if (env.NO_CACHE.toBoolean()) PARAM="--no-cache ${PARAM}"
        app = docker.build("haoling/pinry", PARAM)
    }
    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push(VERSION);
        }
    }
}
