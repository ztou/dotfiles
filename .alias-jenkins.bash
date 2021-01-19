declare -A jenkins_job
jenkins_job[infraworks-desktop]="https://master-3.jenkins.autodesk.com/job/BCG/job/IW"

declare -A org_map
org_map[civil-infrastructure]="Civil-Infrastructure"
org_map[civil3d]="Civil"
org_map[infraworks]="InfraWorks"

function jo() {

    # git@git.autodesk.com:civil-infrastructure/drainage-engine.git
    # https://git.autodesk.com/civil-infrastructure/drainage-engine.git
    url=$(git remote get-url origin)

    # https://tldp.org/LDP/abs/html/parameter-substitution.html

    # git
    org_repo=${url#*com:}

    # https
    org_repo=${org_repo#*com/}
    # org=${org_repo%/*}

    org=$(echo "$org_repo" | cut -d'/' -f 1)
    # echo $org

    repo=$(basename $(git rev-parse --show-toplevel))
    # echo $repo

    # check repo has customized jenkins job url
    lower_repo=$(echo "$repo" | tr '[:upper:]' '[:lower:]')
    jenkins_url=${jenkins_job[$lower_repo]}

    if [ -z "$jenkins_url" ]; then

        lower_org=$(echo "$org" | tr '[:upper:]' '[:lower:]')
        jenkins_org=${org_map[$lower_org]}

        # check repo has cutomized jenkins org/folder
        if [ -z "$jenkins_org" ]; then
            jenkins_org=$org
        fi

        # generate jenkins url with org + repo name
        jenkins_host=https://master-3.jenkins.autodesk.com/job/BCG/job/$jenkins_org
        jenkins_url=$jenkins_host/job/$repo
    fi

    echo opening jenkins job link: $jenkins_url
    open $jenkins_url
}
