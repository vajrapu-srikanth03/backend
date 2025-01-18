@Library('expense-shared-library') _

def config = [
    application: "nodejs",
    component: "backend",
    REPO_URL: "https://github.com/vajrapu-srikanth03/backend.git",
    region : "us-east-1"
]

// Manually set BRANCH_NAME for testing purposes
env.BRANCH_NAME = 'main'
echo "Branch Name: ${env.BRANCH_NAME}"

if( env.BRANCH_NAME?.equalsIgnoreCase('main')){ //Ensure that your Jenkins job is a multibranch pipeline or a GitHub organization job. These job types automatically set the BRANCH_NAME environment variable.
    pipelineDecision.decidePipeline(config)
}
else{
    echo "This is PRODUCTION, deal with CR process"
}
