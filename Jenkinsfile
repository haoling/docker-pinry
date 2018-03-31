node('docker') {
    def app
    def VERSION=env.VERSION
    def BRANCH=env.BRANCH
    def REPO=env.REPO
    stage('Preparation') { // for display purposes
        if (env.NO_CACHE.toBoolean()) cleanWs()
        checkout scm
        if (! VERSION) VERSION="latest"
        if (! BRANCH) BRANCH="origin/my-master"
        if (! REPO) REPO='https://github.com/haoling/pinry.git'
        checkout([$class: 'GitSCM', branches: [[name: BRANCH]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'app']], submoduleCfg: [], userRemoteConfigs: [[url: REPO]]])
    }
    stage('Build') {
        def PARAM="."
        if (env.NO_CACHE.toBoolean()) PARAM="--no-cachie ${PARAM}"
        sh "docker build -t drive.fei-yen.jp:5443/pinry/pinry:latest ${PARAM}"
        sh "docker tag drive.fei-yen.jp:5443/pinry/pinry:latest drive.fei-yen.jp:5443/pinry/pinry:${env.BUILD_NUMBER}"
    }
    stage('Push image') {
        sh "docker push drive.fei-yen.jp:5443/pinry/pinry:latest"
        sh "docker push drive.fei-yen.jp:5443/pinry/pinry:${env.BUILD_NUMBER}"
    }
}
