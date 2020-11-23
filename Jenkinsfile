#!/usr/bin/env groovy
// please look at: https://jenkins.io/doc/book/pipeline/syntax/
BranchName = env.BRANCH_NAME
/* This parameter will schedule builds with custom configurations.
     The below expression means if branch is develop,we will trigger PSRA buildtype at time 8-9 pm and the GenerateAPIDocs at time 9-10 pm */
String param_string_cron = BranchName == "develop" ? "H H(20-21) * * * %buildType=PSRA \nH H(21-22) * * * %GenerateAPIDocs=true \nH H(22-23) * * * %buildType=TICS" : ""

def LogLevel = env.Verbose
def updatedComponents = ["rap"]

/* 'pipeline': This is the start of the pipeline which takes cares of Continuous Integration of the whole OPA code */
pipeline {

/*
'agent': This instruct the Jenkins to allocate a node to run the pipeline
'node': The node/machine on which the Pipeline should run
'label:': label is used to identify a node. Eg:-xcode && 10.0 means nodes where Xcode 10 has been installed.
            We can add custom defined labels to nodes in order to identify them and run the Pipeline on them.
*/
    agent {
        node {
            label 'xcode && 12.0'
        }
    }

/* 'parametes': These parameters define basic configurations to run the build. User can choose the parameters while selecting "build with parameters" in jenkins.
    We can mention default values,parameter name,display name and parameter type while defining them
    'RetainWorkspace': By default whenever a Pipeline execution finishes,it deletes the workspace. If this option is true,it will not delete the workspace
    'Verbose': If this is true, all the pod installs and build will show detailed logs in the Console Output
    'RefAppIPA': If this is true, Ref App iPA will be generated as part of the build.
    'GenerateAPIDocs': If this is true, Apple Docs of all the components will be generated.
    'RunAllTests': By default, in feature branches,only the changed component's test cases are executed. If this is true,all component test cases will be ececuted.
    'Normal\nPSRA': This is the type of build that should be generated from the pipeline. Currenttly there are two types, PSRA and Normal.
     */
    parameters {
        booleanParam(name: 'RetainWorkspace', defaultValue: false, description: 'Retain Workspace')
        booleanParam(name: 'Verbose', defaultValue: false, description: 'Verbose logging')
        booleanParam(name: 'RefAppIPA', defaultValue: false, description: 'Generate RefApp IPA')
        booleanParam(name: 'USRIPA', defaultValue: false, description: 'Generate USR demo App IPA')
        booleanParam(name: 'PIMIPA', defaultValue: false, description: 'Generate PIM demo App IPA')
        booleanParam(name: 'GenerateAPIDocs', defaultValue: false, description: 'Generate API Documentation')
        booleanParam(name: 'RunAllTests', defaultValue: false, description: 'Build and run all unit tests')
        choice(choices: 'Normal\nPSRA\nBlackDuck\nTICS', description: 'What type of build to build?', name: 'buildType')
    }

/*
'triggers': This keyword helps us to configure custom triggers for the pipeline, like nightly build schedule,etc
'parameterizedCron': This is a Jenkins plugin which is used to schedule Builds according to the value given in the variable param_string_cron
defined at the top. The value means schedule Nighlty builds for PSRA and API Doc Generation only on develop branch.
*/
    triggers {
        parameterizedCron(param_string_cron)
    }

/*
'environment': This environment variable is used to make the build take the dependencies either from local or artifactory.
This variable is used in Podfile. false means it will take from local,true means from artifactory.
*/
    environment {
        BUILD_FROM_ARTIFACTORY = 'false'
    }

/*
'options': Used for configured pipeline specific options such as timestamps
'timestamps': Prepend all console output with the timestamp which the line was emitted
'buildDiscarder': This is a Jenkins plugin which keeps the build history for the number mentioned. Eg:- In this case, 24 builds will be kept
'skipDefaultCheckout': Skip checking out code from source control by default
*/
    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '24'))
        skipDefaultCheckout(true)
    }

/*
'stages': This contain all the stages of the Pipeline
'steps': This section defines the one by one steps to be executed in a given stage
'script': is used to execute a shell script in each step of a stage
*/

/**Initialize stage is used to initialize the pipeline which includes following steps
*   1. remove current workspace
*   2. checkout from git. There is a master checkout in the node which is cloned from the actual repo. Each build clones from that local clone,thus decreasing checkout time
*   3. remove build and derived data stuffs
*   4. update pods
*/
    stages {
        stage('Initialize') {
            steps {
                deleteDir()
                script {
                    sh """
                             if [ -d ~/workspace/master ]; then
                                    
                                   git clone ~/workspace/master ${WORKSPACE}
                             fi
                    """
                    checkout([$class: 'GitSCM', branches: [[name: '*/'+env.BRANCH_NAME]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', depth: 0, honorRefspec: true, noTags: false, reference: '', shallow: false, timeout: 20]], userRemoteConfigs: [[credentialsId: 'dd4dd876-0d1a-4af0-bbea-9f726ff85d9a', url: 'ssh://tfsemea1.ta.philips.com:22/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios']]])
                        InitialiseBuild()
                        echo "Removing results and ipa files from path"
                        sh "pwd"
                        sh "rm -rf Source/results/*"
                        sh "rm -rf Source/build/"
                        sh "rm -rf ~/Library/Developer/Xcode/DerivedData"
                        sh "rm -rf Source/DerivedData"
                }
                InitialiseBuild()
                script {
                    sh '''#!/bin/bash -l
                        ./ci-build-support/update_version.sh
                    '''
                    updatedComponents = getUpdatedComponents()
                    echo "changed components: " + updatedComponents
                }
                updatePods("Source",LogLevel)
            }
        }


        /** Zip Components stage is used to zip the source folder which will be published to artifactory in publish stage
        *   1. Using zip shell script it zip each component folder
        *   2. It creates a zip with foldername_commithash.zip. We can give the folder names of what we want to Zip,others will not be zipped
        *   3. Please refer this link for reference: http://artifactory-ehv.ta.philips.com:8082/artifactory/iet-mobile-ios-snapshot-local/com/philips/platform/Zip_Sources/
        */
        stage('Zip Components') {
            when {
                allOf {
                    not { expression { return params.buildType == 'BlackDuck' }}
                    anyOf { branch 'develop'; branch 'release/platform_*' }
                }
                
            }
            steps {
                script {
                    def zipScript =
                    '''#!/bin/bash -xl
                        PODSPEC_PATH="ci-build-support/Versions.rb"
                        VERSION_REGEX="VersionCDP2Platform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
                        COMPONENT_VERSION=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"`
                        COMMIT_HASH=`git rev-parse HEAD`

                        export ZIPFOLDER="Zips"
                        cd Source
                        mkdir -p "${ZIPFOLDER}"
                        mkdir -p "${ZIPFOLDER}/Source"
                        echo "Zipping started"

                        for i in */; do
                            if [ "$i" == "ail/" ] || [ "$i" == "dcc/" ] || [ "$i" == "iap/" ] || [ "$i" == "pif/" ] || [ "$i" == "prg/" ] || [ "$i" == "prx/" ] || [ "$i" == "pse/" ] || [ "$i" == "ufw/" ] || [ "$i" == "usr/" ] || [ "$i" == "pim/" ] || [ "$i" == "ecs/" ]  || [ "$i" == "mec/" ] || [ "$i" == "ccb/" ]; then
                                export ZIPPATH="${ZIPFOLDER}/${i%/}_${COMMIT_HASH}.zip"
                                echo "Creating zip for Component ${i} in path ${ZIPPATH}"
                                cp -R "${i}" "${ZIPFOLDER}/Source/${i}"
                                cd ${ZIPFOLDER}
                                zip -r "../${ZIPPATH}" "Source/${i}"
                                rm -rf Source/*
                                cd -
                            fi
                        done
                        echo "Zipping ended"
                    '''
                    echo zipScript
                    sh zipScript
                }
            }
        }

        /* This stage is used to run unit tests. Only updated components test cases run along with appframework test cases in feature branches */
        stage('Run Unit Tests') {
            when {
                not { expression { return params.buildType == 'BlackDuck' }}
            }
            steps {
                script {
                    def shouldForceUnitTests = false

                    releaseBranchPattern = "release/platform_*"
                    developBranchPattern = "develop"
                    if (BranchName =~ /${releaseBranchPattern}/ || BranchName == developBranchPattern || params.RunAllTests) {
                        shouldForceUnitTests = true
                    }

                    runTestsWith(true, "AppFramework", "AppFramework", true)
                    if (updatedComponents.contains("dcc") || shouldForceUnitTests) {
                        runTestsWith(true, "PhilipsConsumerCareDev", "PhilipsConsumerCare")
                    }
                    if (updatedComponents.contains("prg") || shouldForceUnitTests) {
                        runTestsWith(true, "PhilipsProductRegistrationDev", "PhilipsProductRegistration")
                    }
                    if (updatedComponents.contains("prx") || shouldForceUnitTests) {
                        runTestsWith(true, "PhilipsPRXClientDev", "PhilipsPRXClient Test Report")
                    }
                    if (updatedComponents.contains("iap") || shouldForceUnitTests) {
                        runTestsWith(true, "InAppPurchaseDev", "InAppPurchase")
                    }
                    if (updatedComponents.contains("usr") || shouldForceUnitTests) {
                        runTestsWith(true, "PhilipsRegistrationDev", "PhilipsRegistration")
                    }
                    if (updatedComponents.contains("ail") || shouldForceUnitTests) {
                        runTestsWith(true, "AppInfraDev", "AppInfra")
                    }
                    if (updatedComponents.contains("ufw") || shouldForceUnitTests) {
                        runTestsWith(true, "UAPPFrameworkDev", "UAPPFramework")
                    }
                    if (updatedComponents.contains("pif") || shouldForceUnitTests) {
                        runTestsWith(true, "PlatformInterfacesDev", "PlatformInterfaces")
                    }
                    if (updatedComponents.contains("pse") || shouldForceUnitTests) {
                       runTestsWith(true, "PhilipsProductSelectionDev", "PhilipsProductSelection")
                    }
                    if (updatedComponents.contains("pim") || shouldForceUnitTests) {
                        runTestsWith(true, "PIMDev", "PIM")
                    }
                    if (updatedComponents.contains("ecs") || shouldForceUnitTests) {
                       runTestsWith(true, "PhilipsEcommerceSDKDev", "PhilipsEcommerceSDK")
                    }
                    if (updatedComponents.contains("mec") || shouldForceUnitTests) {
                       runTestsWith(true, "MobileEcommerceDev", "MobileEcommerce")
                    }
                    if (updatedComponents.contains("ccb") || shouldForceUnitTests) {
                       runTestsWith(true, "ConversationalChatbotDev", "ConversationalChatbot")
                    }
                }
            }
        }

        /* This stage is used for generating ipa for reference app. For develop/release branches by default iPA will be generated. For feature branches,
            we have to trigger the build with the RefAppIpa generation turned on */
        stage('Build Ref App') {
            when {
                not { expression { return params.buildType == 'PSRA' } }
                not { expression { return params.buildType == 'BlackDuck' } }
                anyOf {
                    expression { return params.RefAppIPA }
                    anyOf { branch 'develop'; branch 'release/platform_*' }
                }
            }
            steps {
                    runBuildWithIPA(true,"AppFramework","rap/Source/App/AppFramework")
            }
        }

        /* This stage will generate Apple Docs based on params.GenerateAPIDocs flag, using the script present in path, "ci-build-support/generateApiDocs.sh" */
        stage('Generate API Documentation') {
            when {
                not { expression { return params.buildType == 'BlackDuck' } }
                anyOf {
                    expression { return params.GenerateAPIDocs }
                    anyOf { branch 'release/platform_*' }
                }
            }
            steps {
                script {
                    sh "ci-build-support/generateApiDocs.sh"
                }

                publishHTML target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: 'API_DOCS',
                    reportFiles: 'index.html',
                    reportName: 'API Documentation'
                ]
            }
        }

        // stage('Trigger Incontext Test') {
        //     when {
        //         allOf {
        //             not { expression { return params.buildType == 'PSRA' } }
        //             anyOf { branch 'develop'; branch 'release/platform_*' }
        //         }
        //     }
        //     steps {
        //         script {
        //             build job: 'Platform-Infrastructure/IncontextTest/master', parameters: [string(name: 'branchname', value:BranchName), string(name: 'triggered_from', value:'Platform'), string(name: 'os_platform', value:'iOS')], wait: false
        //         }
        //     }
        // }

        /* This stage will generate User Registration demo app iPA. If the USRIPA build parameter is set,it will generate the iPA */
        stage('Build Demo Apps') {
            when {
                   allOf {
                        expression { return params.USRIPA }
                }
            }
            steps {
                
                 runBuildWithIPA(true,"USRDemoApp","usr/Source/DemoApp")
            }
        }
        
        /* This stage will generate PIM demo app iPA */
        stage('Build PIM Demo App') {
            when {
                   anyOf {
                        expression { return params.PIMIPA }
                        anyOf { branch 'develop'; branch 'release/platform_*' }
                }
            }
            steps {
                
                 runBuildWithIPA(true,"PIMDemoApp","pim/Source/DemoApp")
            }
        }

        /* This stage will generate the PSRA iPA for Reference App if build type is set to PSRA*/
        stage('Build PSRA App') {
            when {
             anyOf {
                    expression { return params.buildType == 'PSRA' }
                    }
        }
            steps {
                runBuildWithIPA(true,"PSRARelease","rap/Source/App/AppFramework")
            }
        }


        /** This stage is used to publish each components zip generate in the Zip stage to artifactory
        *   Zips are uploaded to snapshot-local or snapshot-release based on develop or release branch
        *   Version is captured from "ci-build-support/Versions.rb" file
        *   shell curl command is used to upload the zips,using IET Functional Account credentials
        */
        stage('Publish Zips') {
            when {
                not { expression { return params.buildType == 'BlackDuck' } }
                not { expression { return params.buildType == 'TICS' } }
                anyOf { branch 'develop'; branch 'release/platform_*' }
            }
            steps {
                script {
                    boolean ReleaseBranch = (BranchName ==~ /release\/platform_.*/)
                    def publishScript =
                    '''#!/bin/bash -l
                        PODSPEC_PATH="ci-build-support/Versions.rb"
                        VERSION_REGEX="VersionCDP2Platform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
                        COMPONENT_VERSION=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"`
                        if [ '''+ReleaseBranch+''' = true ]
                        then
                            ARTIFACTORY_REPO="iet-mobile-ios-release-local"
                        else
                            ARTIFACTORY_REPO="iet-mobile-ios-snapshot-local"
                        fi

                        export ZIPFOLDER="Zips"
                        export ARTIFACTORY_URL="https://artifactory-ehv.ta.philips.com/artifactory/${ARTIFACTORY_REPO}/com/philips/platform/Zip_Sources"
                        cd Source
                        echo "Upload started"
                        cd ${ZIPFOLDER}
                        rm -rf Source
                        pwd
                        for i in *; do
                            export ARTIFACTORYUPLOADURL="${ARTIFACTORY_URL}/${COMPONENT_VERSION}/${i}"
                            echo "Uploading Zip for $i at path ${ARTIFACTORYUPLOADURL}"
                            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "${ARTIFACTORYUPLOADURL}" -T $i
                        done
                        echo "Upload ended"
                        cd -
                        echo "Removing Zips Folder"
                        rm -rf ${ZIPFOLDER}
                    '''
                    echo publishScript
                    sh publishScript
                }
            }
        }


        /** Publish podspecs stage is used to publish podspecs to tfs Podspec repo
        *   Podspecs are pubished only from develop or release branch as mentioned in when condition
        *   It calls publish method which basically handles the script to be used to publish it to podspec repo
        * List all the podspecs to be uploaded in this below stage
        */
        stage('Publish Podspecs') {
            when {
                not { expression { return params.buildType == 'BlackDuck' } }
                not { expression { return params.buildType == 'TICS' } }
                anyOf { branch 'develop'; branch 'release/platform_*' }
            }
            steps {
                script {
                    publish("./PlatformInterfaces.podspec", "./Source/Podfile.lock")
                    publish("./AppInfra.podspec", "./Source/Podfile.lock")
                    publish("./AppInfraMicroApp.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsPRXClient.podspec", "./Source/Podfile.lock")
                    publish("./UAPPFramework.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsRegistration.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsRegistrationMicroApp.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsProductSelection.podspec", "./Source/Podfile.lock")
                    publish("./InAppPurchase.podspec", "./Source/Podfile.lock")
                    publish("./InAppPurchaseDemoUApp.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsConsumerCare.podspec", "./Source/Podfile.lock")
                    publish("./ConsumerCareMicroApp.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsProductRegistration.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsProductRegistrationUApp.podspec", "./Source/Podfile.lock")
                    publish("./PIM.podspec", "./Source/Podfile.lock")
                    publish("./PIMDemoUApp.podspec", "./Source/Podfile.lock")
                    publish("./PhilipsEcommerceSDK.podspec", "./Source/Podfile.lock")
                    publish("./MobileEcommerce.podspec", "./Source/Podfile.lock")
                    publish("./ConversationalChatbotDemoUApp.podspec", "./Source/Podfile.lock")
                    publish("./ConversationalChatbot.podspec", "./Source/Podfile.lock")
                }
            }
        }


        /** Publish Ref App stage publish the ref app ipa to artifactory
        *   Also generates BOM file which contains all the component and their dependency versions to be uploaded to Confluence
        */
        stage('Publish Ref App') {
            when {
                not { expression { return params.buildType == 'PSRA' } }
                not { expression { return params.buildType == 'BlackDuck' } }
                not { expression { return params.buildType == 'TICS' } }
                anyOf {
                    expression { return params.RefAppIPA }
                    anyOf { branch 'develop'; branch 'release/platform_*' }
                }
            }
            steps {
                publishRefIPA()
                generateBOMFileforConfluence("./Source/Podfile.lock", "./Source/BOMFileConfluence.txt")
                script {
                    archiveArtifacts 'Source/Podfile.lock'
                    archiveArtifacts 'Source/build/RefApp_*.ipa'
                    archiveArtifacts 'Source/BOMFileConfluence.txt'
                }
            }
        }

        /* Publish UserRegistrationDemo App stage ipa */
        stage('Publish Demo Apps') {
            when {
                not { expression { return params.buildType == 'BlackDuck' } }
                not { expression { return params.buildType == 'TICS' } }
                allOf {
                    expression { return params.USRIPA }
                }
            }
            steps {
                publishUsrIPA()
                archiveArtifacts 'Source/build/registration_*.ipa'
            }
        }
        
        /* Publish PIMDemoApp stage ipa */
        stage('Publish PIM App') {
            when {
                not { expression { return params.buildType == 'BlackDuck' } }
                not { expression { return params.buildType == 'TICS' } }
                anyOf {
                    expression { return params.PIMIPA }
                    anyOf { branch 'develop'; branch 'release/platform_*' }
                }
            }
            steps {
                publishPimIPA()
                archiveArtifacts 'Source/build/pim_*.ipa'
            }
        }

        /* Publish psra app ipa to Artifactory */
        stage('Publish PSRA App') {
            when {
                expression { return params.buildType == 'PSRA' }
                not { expression { return params.buildType == 'TICS' } }
            }
            steps {
                publishRefIPA()
                script {
                    archiveArtifacts 'Source/Podfile.lock'
                    archiveArtifacts 'Source/build/RefApp_*.ipa'
                }
            }
        }

        stage('TICS EMS') {
            when {
               expression { return params.buildType == 'TICS' }
        }
            steps {
                script {
                    echo "Running TICS..."
                    sh """#!/bin/bash -l
                        set -e
                        chmod +x tics_iet_mobile.sh
                        dos2unix  tics_iet_mobile.sh
                        ./tics_iet_mobile.sh
                    """
                }
            }
        }



        /* Publish api docs */
        stage('Publish API Docs') {
            when {
                expression { return params.GenerateAPIDocs }
                not { expression { return params.buildType == 'BlackDuck' } }
                not { expression { return params.buildType == 'TICS' } }
            }
            steps {
                publishAPIDocs()
            }
        }

        /* Blackduck Analytics */
        stage('Blackduck Analytics') {
            when {
                expression { return params.buildType == 'BlackDuck' }
            }
            steps {
                analyzeWithBlackduck()
            }
        }


        /* This stage triggers the E2E Test Pipeline for running automation regression test suite on Ref App iPA.*/

        // stage('Trigger E2E Test') {
        //     when {
        //         anyOf { branch 'develop'; branch 'release/platform_*' }
        //     }
        //     steps {
        //         script {
        //             IPA_NAME = readFile ("Source/build/ipaname.txt").trim()
        //             echo "IPA_NAME = ${IPA_NAME}"
        //             def jobBranchName = "release_platform_1805"
        //             if (BranchName =~ /develop/) {
        //                jobBranchName = "develop"
        //             }
        //             echo "BranchName changed to ${jobBranchName}"
        //
        //             sh """#!/bin/bash
        //                 curl -X POST http://platform-ubuntu-ehv-002.ddns.htc.nl.philips.com:8080/job/Platform-Infrastructure/job/E2E_Tests/job/E2E_iOS_${jobBranchName}/buildWithParameters?IPAPATH=$IPA_NAME
        //             """
        //         }
        //     }
        // }
    }

/*
'post': Last stage which is always called before the Pipeline execution finishes and all other stages have been executed
'always': run the steps regardless of the pipeline status
'notifyBuild': sends mail when the build status is aborted/failed/fixed and unstable
'script': for adding condition and run script after the complition of stage
*/
    /* This is post script to notify current build status and retain workspace as per params.RetainWorkspace flag */
    post {
        always{
            notifyBuild(currentBuild.result)
            script {
                 if (!params.RetainWorkspace) {
                     echo "Removing Workspace"
                     deleteDir()
                 } else {
                     echo "Skipping Workspace removal"
                 }
            }
        }
    }
}

/* Notifies the build status to configured email list */
def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successfull
    buildStatus =  buildStatus ?: 'aborted' || 'failure' || 'fixed' || 'unstable'
   // Default values
   def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
   def details = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]': Check console output at ${env.BUILD_URL}"

    emailext (
        subject: subject,
        body: details,
        to: "dl_iet_amaron@philips.com, dl_iet_exide@philips.com, venkata.kishore@philips.com"
    )
}


/* Describes the build like submitter, node name. Called from Initialise stage */
def InitialiseBuild() {
    committerName = sh (script: "git show -s --format='%an' HEAD", returnStdout: true).trim()
    currentBuild.description = "Submitter: " + committerName + ";Node: ${env.NODE_NAME}"
    echo currentBuild.description

    if (params.buildType == 'PSRA') {
        currentBuild.displayName = "${env.BUILD_NUMBER}-PSRA"
    }

    echo currentBuild.displayName
}

/* check for updated components in OPA. This is used in order to run Unit test cases of only the changed components in feature branch */
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


/* This method runs unit test cases for scheme name passed in the workspace
*  xcodebuild command is used to run test scheme
*  Test case results are generated through xcpretty and published
*/
def runTestsWith(Boolean isWorkspace, String testSchemeName, String frameworkName = " ", Boolean isApp = false, Boolean hasCucumberOutput = false) {

    // This is only used for code coverage and test result output/attachments
    def resultBundlePath = "results/" + testSchemeName
    def binaryPath = frameworkName  + "/"+ frameworkName + ".framework/" + frameworkName
    if (isApp) {
        binaryPath = frameworkName+ ".app"  + "/" + frameworkName
    }
    
    def testScript = """
        #!/bin/bash -l
        export PATH=/.rbenv/shims:/usr/local/bin/xcpretty/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

        killall Simulator || true
        xcrun simctl erase all || true

        cd ${"Source"}

        #Set XCPretty output format
        export LC_CTYPE=en_US.UTF-8

        xcodebuild test \
                -workspace ${"PLF-IOS-WORKSPACE.xcworkspace"} \
                -scheme ${testSchemeName} CLANG_WARN_DOCUMENTATION_COMMENTS='NO'\
                -destination \'platform=iOS Simulator,name=iPhone 8,OS=latest\' \
                -UseModernBuildSystem='YES'\
                -resultBundlePath ${resultBundlePath} \
                | xcpretty --report junit --report html
        
        mkdir -p "Coverage"
        if [ -d "${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4" ]
            then
                echo "Directory exists in iet-iOS-blr-001"
                    if [ "$testSchemeName" == "AppFramework" ]
                        then
                            xcrun llvm-cov show ${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/${testSchemeName}.app/${testSchemeName} -instr-profile=${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4/Coverage.profdata -arch=x86_64 &> ${WORKSPACE}/Source/Coverage/llvm-cov-show-AppFramework_Profile.txt
                    elif [ "$testSchemeName" == "AppInfraDev" ] 
                        then
                            xcrun llvm-cov show ${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/${frameworkName}.framework/${frameworkName} -instr-profile=${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4/Coverage.profdata -arch=x86_64 &> ${WORKSPACE}/Source/Coverage/llvm-cov-show-${testSchemeName}_Profile.txt
                    else
                        xcrun llvm-cov show ${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/${testSchemeName}.framework/${testSchemeName} -instr-profile=${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/4B0465A0-EB0F-47D0-97A6-15FCB16B26E4/Coverage.profdata -arch=x86_64 &> ${WORKSPACE}/Source/Coverage/llvm-cov-show-${testSchemeName}_Profile.txt
                    fi
        elif [ -d "${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57" ]
            then
                echo "Directory exists in iet-iOS-blr-002"
                    if [ "$testSchemeName" == "AppFramework" ]
                        then
                            xcrun llvm-cov show ${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/${testSchemeName}.app/${testSchemeName} -instr-profile=${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57/Coverage.profdata -arch=x86_64 &> ${WORKSPACE}/Source/Coverage/llvm-cov-show-AppFramework_Profile.txt
                    elif [ "$testSchemeName" == "AppInfraDev" ] 
                        then
                            xcrun llvm-cov show ${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/${frameworkName}.framework/${frameworkName} -instr-profile=${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57/Coverage.profdata -arch=x86_64 &> ${WORKSPACE}/Source/Coverage/llvm-cov-show-${testSchemeName}_Profile.txt
                    else
                        xcrun llvm-cov show ${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/products/Debug-iphonesimulator/${testSchemeName}.framework/${testSchemeName} -instr-profile=${WORKSPACE}/Source/DerivedData/PLF-IOS-WORKSPACE/Build/ProfileData/BF86F4D9-4F86-4F54-AB68-562AEEE9AE57/Coverage.profdata -arch=x86_64 &> ${WORKSPACE}/Source/Coverage/llvm-cov-show-${testSchemeName}_Profile.txt
                    fi
        else    
            echo "Error: Directory does not exist in both the nodes"
        fi
    """
    
    echo testScript
    sh testScript

    junit allowEmptyResults: false, testResults: "Source/build/reports/junit.xml"
    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: "Source/build/reports", reportFiles: 'tests.html', reportName: frameworkName+' Test Report'])

    if (hasCucumberOutput) {
        def attachmentsFolder = 'Source/'+resultBundlePath+'/Attachments'
        step([$class: 'CucumberReportPublisher', jsonReportDirectory: attachmentsFolder, fileIncludePattern: '*.json'])
        archiveArtifacts artifacts: attachmentsFolder+'/*.json', fingerprint: true, onlyIfSuccessful: true
    }
}


/* This method builds,archives and generates iPA for the scheme passed using xcodebuild command
*/
def runBuildWithIPA(Boolean LogLevel, String schemeName, String exportPath) {
    def buildScript = """
    #!/bin/bash -l

    killall Simulator || true
    export LC_CTYPE=en_US.UTF-8

    cd ${"Source"}

    if [ ${LogLevel} == "true" ]
        then
            xcodebuild clean archive -workspace ${"PLF-IOS-WORKSPACE.xcworkspace"} -configuration Release -scheme ${schemeName} CLANG_WARN_DOCUMENTATION_COMMENTS='NO' -archivePath build/${schemeName} -UseModernBuildSystem='YES'
            xcodebuild -exportArchive -exportOptionsPlist ${exportPath}/exportOptions.plist -archivePath "build/${schemeName}.xcarchive/" -exportPath "build/" -UseModernBuildSystem='YES'
        else
            xcodebuild clean archive -quiet -workspace ${"PLF-IOS-WORKSPACE.xcworkspace"} -configuration Release -scheme ${schemeName} CLANG_WARN_DOCUMENTATION_COMMENTS='NO' -archivePath build/${schemeName} | xcpretty -UseModernBuildSystem='YES'
            xcodebuild -quiet -exportArchive -exportOptionsPlist ${exportPath}/exportOptions.plist -archivePath "build/${schemeName}.xcarchive/" -exportPath "build/" | xcpretty -UseModernBuildSystem='YES'
    fi

    if [ \$? != 0 ]
        then
            exit 1
    fi
    """

    echo buildScript
    sh buildScript
}


/* This method invokes the ci-build-support/podspec_immutable_dependencies.sh script which creates the Podspec of the components passed to the method
 and publishes it to the podspec repo */
def publish(String podspecPath, String podfileLockPath) {
    sh """#!/bin/bash -l
        chmod 755 ./ci-build-support/podspec_immutable_dependencies.sh
        chmod 755 ./ci-build-support/substitute_version.groovy
        ci-build-support/podspec_immutable_dependencies.sh ${podspecPath} ${podfileLockPath} $BRANCH_NAME
        ci-build-support/podspec_push.sh ${podspecPath} $BRANCH_NAME
    """
}


/* Generate BOM file to track all component versions present in podfile.lock using "ci-build-support/CreateBOMFromPodfile.groovy" script file */
def generateBOMFileforConfluence(String podfileLockPath, String outputFile) {
    sh """#!/bin/bash -l
        ci-build-support/CreateBOMFromPodfile.groovy -i ${podfileLockPath} -o ${outputFile}
    """
}


/* Get artifactory base path which may be snapshot-local or release-local based on develop or release branch */
String getArtifactoryBasePath() {
    boolean ReleaseBranch = (BranchName ==~ /release\/platform_.*/)
    boolean DevelopBranch = (BranchName ==~ /develop/)

    def basePathShellScript = '''#!/bin/bash -l
        ARTIFACTORY_URL="https://artifactory-ehv.ta.philips.com/artifactory"

        if [ '''+ReleaseBranch+''' = true ]
        then
            ARTIFACTORY_REPO="iet-mobile-ios-release-local"
        elif [ '''+DevelopBranch+''' = true ]
        then
            ARTIFACTORY_REPO="iet-mobile-ios-snapshot-local"
        else
            echo ""
            exit 0
        fi

        echo "$ARTIFACTORY_URL/$ARTIFACTORY_REPO/com/philips/platform"
    '''

    return sh(script: basePathShellScript, returnStdout: true).trim()
}


/* Get platform version number from ci-build-support/Versions.rb file */
String getCDP2PlatformVersionNumber() {
    def versionNumberShellScript = '''#!/bin/bash -l
        VERSIONS_FILE_PATH="ci-build-support/Versions.rb"

        if [ ! -f "${VERSIONS_FILE_PATH}" ]
        then
            echo ""
            exit 1
        fi

        VERSION_REGEX="VersionCDP2Platform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
        cat $VERSIONS_FILE_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"
    '''

    return sh(script: versionNumberShellScript, returnStdout: true).trim()
}


/* This method uses curl command to publish the generated API doc zip file to artifactory. */
def publishAPIDocs() {
    String artifactoryBasePath = getArtifactoryBasePath()
    String versionNumber = getCDP2PlatformVersionNumber()

    echo "Using Artifactory BasePath ["+artifactoryBasePath+"]"
    echo "using versionNumber ["+versionNumber+"]"

    def shellcommand = '''#!/bin/bash -l
        set -e

        if [ -z "'''+artifactoryBasePath+'''" ]
        then
            echo "Not published as build is not on a develop or release branch" . $BranchName
            exit 0
        fi

        API_DOC_ZIP="API_DOCS_'''+versionNumber+'''.zip"
        zip -r $API_DOC_ZIP API_DOCS
        curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/API_DOCS/ -T $API_DOC_ZIP
    '''
    echo shellcommand
    sh shellcommand
}


/* This method uses the curl command to publish the RefAppIPA file to artifactory
*  It moves to build directory and search for PSRA build or normal build ipa file
*/
def publishRefIPA() {
    boolean PSRABuild = (params.buildType ==~ /PSRA/)
    String artifactoryBasePath = getArtifactoryBasePath()
    String versionNumber = getCDP2PlatformVersionNumber()

    def shellcommand = '''#!/bin/bash -l
        RefApp_VERSION="'''+versionNumber+'''"

        DSYM_NAME="RefApp_"$RefApp_VERSION"_dSYMs.zip"
        ZIPFILE_NAME="plf_Binary_"$RefApp_VERSION".zip"
        PODLOCK_NAME="RefApp_"$RefApp_VERSION"-Podfile.lock"

        BASE_PATH=`pwd`
        cd Source/build/

        if [ '''+PSRABuild+''' = true ]
        then
            IPA_NAME="RefApp_"$RefApp_VERSION"_PSRA.ipa"
            mv PSRARelease.ipa $IPA_NAME
        else
            IPA_NAME="RefApp_"$RefApp_VERSION".ipa"
            mv AppFramework.ipa $IPA_NAME
        fi

        if [ -z "'''+artifactoryBasePath+'''" ]
        then
            echo "Not published as build is not on a develop or release branch" . $BranchName
        else
            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/referenceApp/build/ -T $IPA_NAME
            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/referenceApp/build/$PODLOCK_NAME -T ../Podfile.lock
            echo ""'''+artifactoryBasePath+'''"/referenceApp/build/$IPA_NAME" > ipaname.txt
            zip -r $DSYM_NAME  ./AppFramework.xcarchive/dSYMs
            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/referenceApp/build/ -T $DSYM_NAME
            cd "../DerivedData/PLF-IOS-WORKSPACE/Build/Intermediates.noindex/ArchiveIntermediates/AppFramework/IntermediateBuildFilesPath/UninstalledProducts/iphoneos"
            zip -r $ZIPFILE_NAME .
            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/plf_Binary/ -T $ZIPFILE_NAME
        fi

        if [ $? != 0 ]
        then
            exit 1
        else
            cd $BASE_PATH
        fi
    '''
    echo shellcommand
    sh shellcommand
}


/* This method uses the curl command to publish USR ipa file in artifactory. */
def publishUsrIPA() {
    String artifactoryBasePath = getArtifactoryBasePath()
    String versionNumber = getCDP2PlatformVersionNumber()

    def shellcommand = '''#!/bin/bash -l
        COMPONENT_VERSION="'''+versionNumber+'''"

        BASE_PATH=`pwd`
        cd Source/build
        IPA_NAME="registration_"$COMPONENT_VERSION".ipa"
        mv USRDemoApp.ipa $IPA_NAME

        if [ -z '''+artifactoryBasePath+''' ]
        then
            echo "Not published as build is not on a master, develop or release branch" . $BranchName
        else
            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/RegistrationSampleApp/ -T $IPA_NAME
        fi

        if [ $? != 0 ]
        then
            exit 1
        else
            cd $BASE_PATH
        fi
    '''
    echo shellcommand
    sh shellcommand
}

/* This method uses the curl command to publish USR ipa file in artifactory. */
def publishPimIPA() {
    String artifactoryBasePath = getArtifactoryBasePath()
    String versionNumber = getCDP2PlatformVersionNumber()

    def shellcommand = '''#!/bin/bash -l
        COMPONENT_VERSION="'''+versionNumber+'''"

        BASE_PATH=`pwd`
        cd Source/build
        IPA_NAME="pim_"$COMPONENT_VERSION".ipa"
        mv UDIDemoApp.ipa $IPA_NAME

        if [ -z '''+artifactoryBasePath+''' ]
        then
            echo "Not published as build is not on a master, develop or release branch" . $BranchName
        else
            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/PIMSampleApp/ -T $IPA_NAME
        fi

        if [ $? != 0 ]
        then
            exit 1
        else
            cd $BASE_PATH
        fi
    '''
    echo shellcommand
    sh shellcommand
}


/* This method removes podfile.lock then cleans pod cache, do pod repo update and then install pods */
def updatePods(String podfilePath, String logLevel) {
    sh '''#!/bin/bash -l
         rm -rf ./Source/Podfile.lock
    '''
    echo "Running pod install for ${podfilePath}"
    if (logLevel == "true") {
        sh '''#!/bin/bash -l
            cd ./Source && pod cache clean --all && pod repo update --verbose && pod install --verbose
        '''
    } else {
        sh '''#!/bin/bash -l
            cd ./Source && pod cache clean --all && pod repo update && pod install
        '''
    }
}

def analyzeWithBlackduck() {
    def runBlackduck = """
        #!/bin/bash -l
        
        java -jar /Users/philips/Softwares/synopsys-detect-6.1.0.jar --detect.project.name=EMS --detect.project.version.name=iOS_10.0 --detect.source.path=${WORKSPACE} --blackduck.url=https://blackduck.philips.com/ --blackduck.trust.cert=true --blackduck.api.token=ZGY1NzY4YWEtMWEzYi00Y2U2LTgzY2QtZjI0NjFkZTQxNTliOjc2ZmYzMzViLTBmMTMtNDlhYy05ZjhmLTViNjgxOTkxMDVmNA==
    """

    echo "-----------------------------"
    echo "Starting Blackduck Analytics"
    echo "-----------------------------"
    sh runBlackduck
    echo "-----------------------------"
    echo "Completing Blackduck Analytics"
    echo "-----------------------------"
}

