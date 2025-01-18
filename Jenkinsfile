@Library('expense-shared-library') _

def config = [
    application: "nodejs",
    component: "backend"
    
]

env.REPO_URL="https://github.com/vajrapu-srikanth03/backend.git"

if( env.BRANCH_NAME?.equalsIgnoreCase('main')){
    pipelineDecision.decidePipeline(config)
}
else{
    echo "This is PRODUCTION, deal with CR process"
}
