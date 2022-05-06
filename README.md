## Terraform solution
### Required 
Terraform version = "~> 1.0"
AWS CLI 2
AWS account
 
### Backend - S3 bucket, Lambda functions and API Gateway
To deploy,configure your AWS CLI with your credentials then run terraform init and terraform apply.
It deploys 2 Lambda functions from the hello-world NodeJS application in the hello-world directory and exposes them using API gateway. Lambda code is stored in S3.
Edit the variables as required.

#### Test the API
You can make GET requests using the curl command line tool.

curl "base-url/hello" and curl "base-url/hello?Name=David"<br/>
curl "base-url/learn" and curl "base-url/learn?Name=David" 

<br/>

