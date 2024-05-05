#!/usr/bin/env bash

function jenkins_lint() {

    # Usages: jenkins_lint <Jenkinfile> <Jenkins URL>
    JENKINS_FILE="${1-Jenkinsfile}"
    JENKINS_URL="${2-https://jenkins-prod.dev.box.net}"
    # JENKINS_USER="vaibhavgupta"
    # JENKINS_TOKEN="__GHE_TOKEN__"
    [ -z "$JENKINS_USER" ] && echo 'Error: Global variable JENKINS_USER is not set.' && return 
    [ -z "$JENKINS_TOKEN" ] && echo 'Error: Global variable JENKINS_TOKEN is not set. This is github Token.' && return 
    JENKINS_AUTH="${JENKINS_USER}:${JENKINS_TOKEN}"

    curl -X POST --user "${JENKINS_AUTH}" -F "jenkinsfile=<${JENKINS_FILE}" "$JENKINS_URL/pipeline-model-converter/validate"
}

jenkins_lint "$1" "$2"
