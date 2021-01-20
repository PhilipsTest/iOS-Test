def updatedComponents = getUpdatedComponents();

def getUpdatedComponents() {
    releaseBranchPattern = "release/platform_*"
    developBranchPattern = "develop"
    if (BranchName =~ /${releaseBranchPattern}/ || BranchName == developBranchPattern) {
        return ["rap"]
    }
    commit_to_compare_with = "${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}"
    if (env.GIT_PREVIOUS_SUCCESSFUL_COMMIT == null) {
        commit_to_compare_with = "origin/develop"
    }
    scriptValue = "git diff --name-only " + commit_to_compare_with
    scriptResult = sh (script: scriptValue, returnStdout: true).trim()
    changed_files = scriptResult.tokenize('\n')
    changed_files.remove("Jenkinsfile")
    changed_files.remove("ci-build-support/Versions.rb")
    echo "Updated files:" + changed_files
    def components = []
    changed_files.each {
        pathComponents = it.split("/")
        if (pathComponents.length > 1) {
            components << pathComponents[1]
        }
    }
    return components
}
