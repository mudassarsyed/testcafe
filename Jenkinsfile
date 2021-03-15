import org.jenkinsci.plugins.pipeline.modeldefinition.Utils
node{
//   agent any
    try{
        properties(
            [parameters(
                [
                    credentials(
                    credentialType: 'com.browserstack.automate.ci.jenkins.BrowserStackCredentials', 
                    defaultValue: '<default_username_placeholder>', 
                    description: 'Select your BrowserStack Username', 
                    name: 'BROWSERSTACK_USERNAME', 
                    required: true), 
                    
                    [
                        $class: 'ExtensibleChoiceParameterDefinition', 
                        choiceListProvider: [
                            $class: 'TextareaChoiceListProvider', 
                            addEditedValue: false, 
                            choiceListText: 
                                '''
                                single
                                parallel-1
                                parallel-2
                                mobile
                                fail
                                local
                                ''', 
                            defaultChoice: 'single'
                        ], 
                        description: 'Select the test you would like to run on BrowserStack', 
                        editable: false, 
                        name: 'TEST_TYPE'
                    ]
                    ]
                )]
            )
    
        stage('Prepare Environment (install dependencies, etc)') {
      
             sh label: '', returnStatus: true, script: '<npm_install and other prereqs_placeholder>'
        
        }

       stage('Pull repository from GitHub') {
      
            git '<github-repo-link_placeholder>'
        
        }
        
        stage('Start Local Server') {
            
            if ( "${params.TEST_TYPE}" == 'local' ) {
                sh label: 'Local Server', returnStatus: true, script: '<app start code placeholder/ app stored on jenkins server workspace?>'
            }
            else {
                Utils.markStageSkippedForConditional('Start Local Server')
            }
            
        }


       
        stage('Initiate tests on BrowserStack') {
            
            browserstack("${params.BROWSERSTACK_USERNAME}") {
                def user = "${env.BROWSERSTACK_USERNAME}"
                if ( user.contains('-')) {
                    user = user.substring(0, user.lastIndexOf("-"))
                }
                withEnv(['BROWSERSTACK_USERNAME=' + user]) {
                    sh label: '', 
                    returnStatus: true, 
                    script: 
                    '''#!/bin/bash -l
                        <test execution command_placeholder> "${TEST_TYPE}"
                    '''
                }
            }

        }
    } catch (e) {
        currentBuild.result = 'FAILURE'
        throw e
    } finally {

    }

}
