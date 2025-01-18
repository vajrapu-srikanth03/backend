@Library('expense-shared-library') _

def config = [
    application: "nodejs",
    component: "backend"
    
]

if( env.BRANCH_NAME.equalsIgnoreCase('main')){
    pipelineDecision.decidePipeline(config)
}
else{
    echo "This is PRODUCTION, deal with CR process"
}
