

function jo() {

    # git@git.autodesk.com:civil-infrastructure/drainage-engine.git
    # https://git.autodesk.com/civil-infrastructure/drainage-engine.git
    url=$(git remote get-url origin)

    # https://tldp.org/LDP/abs/html/parameter-substitution.html

    # git
    org_repo=${url#*com:}

    # https
    org_repo=${org_repo#*com/}
    echo $org_repo
    # org=${org_repo%/*}

    org=$(echo "$org_repo" | cut -d'/' -f 1)
    # echo $org

    repo=$(basename $(git rev-parse --show-toplevel))
    # echo $repo

    jenkins_org=$org
    if [[ "${org}" == "civil-infrastructure"  ]]; then
        jenkins_org=Civil-Infrastructure
    elif [[ "${org}" == "Civil3D"  ]]; then
        jenkins_org=Civil
    fi

    jenkins_host=https://master-3.jenkins.autodesk.com/job/BCG/job/$jenkins_org

    # https://master-3.jenkins.autodesk.com/job/BCG/job/Civil-Infrastructure/job/drainage-engine/
    jenkins_url=$jenkins_host/job/$repo
    echo opening jenkins job link: $jenkins_url
    open $jenkins_url

}
