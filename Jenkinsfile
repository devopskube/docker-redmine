#!/usr/bin/env groovy
/* Only keep the 5 most recent builds. */
def projectProperties = [
        buildDiscarder(logRotator(numToKeepStr: '5')),
        disableConcurrentBuilds(),
        [$class: 'GithubProjectProperty', displayName: 'Docker Redmine', projectUrlStr: 'https://github.com/devopskube/docker-redmine.git']
]

properties(projectProperties)

def tag_name = ''
def image_name = 'devopskube/redmine'
def dockerUser = "${System.getenv('DOCKER_USER')}"
def dockerPwd = "${System.getenv('DOCKER_PWD')}"

podTemplate(label: 'docker-mysql', containers: [
            containerTemplate(name: 'jnlp', image: 'jenkinsci/jnlp-slave:2.62-alpine', args: '${computer.jnlpmac} ${computer.name}'),
            containerTemplate(name: 'docker', image: 'docker:1.12.3-dind', ttyEnabled: true, command: 'cat', privileged: true, instanceCap: 1)
        ],
        volumes: [
            hostPathVolume(mountPath: "/var/run/docker.sock", hostPath: "/var/run/docker.sock")
        ]) {
    node() {
        stage('Checkout') { // happens on master?
            git url: 'https://github.com/devopskube/docker-redmine.git'
            tag_name = sh (
                    script: 'git tag -l --points-at HEAD',
                    returnStdout: true
            ).trim()
        }
        container('docker') {
            stage('Build') {
                println("Build ${image_name}")
                sh("docker build -t ${image_name} .")
            }
            stage('Tag and Push latest') {
                println("Tagging ${image_name}:latest")
                sh "docker tag ${image_name} ${image_name}:latest"

                println("Login in to docker registry")
                sh "docker login --username ${dockerUser} --password ${dockerPwd}"

                println("pushing latest")
                sh "docker push ${image_name}:latest"
            }
            stage('Tag and Push concrete Tag') {
                if (tag_name?.trim()) {
                    println("Tagging ${image_name}:${tag_name}")
                    sh "docker tag ${image_name} ${image_name}:${tag_name}"

                    println("Login in to docker registry")
                    sh "docker login --username ${dockerUser} --password ${dockerPwd}"

                    println "pushing ${tag_name}"
                    sh "docker push ${image_name}:${tag_name}"
                }
                else {
                    println("Pushing concrete Tag not necessary")
                }
            }
        }
    }
}
