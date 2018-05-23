Terraform Demo

Author: Rafael Nize
github: rafaelnize

This document README.md follows the intructions sent by e-mail.

----------------------
Getting Started
-----------------------
These instructions will get you a copy of the the project up and running on your local machine and AWS account. This software is for testing purposes. Its use on production is discouraged.

---------------------
Prerequisites
---------------------
Terraform
awscli 
AWS account

Make sure you have the awscli installed properly on you bastion host or workstation

If you don't have any aws credentials at ~/.aws/credentials you can create one using:

    aws configure

Keep credentials outside the source tree!!!

Make sure the current time and date in your workstation is correct otherwise, aws cli won't work properly.

-------------------------------
Install Terraform
--------------------------------
To install terraform, follow instructions at:
https://www.terraform.io/intro/getting-started/install.html

Make sure terraform binary is in your OS Path environment variable !

------------------------
Check installation
------------------------
execute the following command to make sure terraform runs fine:

terraform version

If it success you'll see Terraform's version.

---------------------------
Code tree - master branch
---------------------------

├── fargate
│   ├── exec_create_fargate.sh
│   ├── file.out
│   ├── main.tf
│   ├── terraform.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
├── modules
│   ├── fargate
│   │   ├── interface.tf
│   │   └── main.tf
│   ├── static_website
│   │   ├── deployer_policy.json
│   │   ├── interface.tf
│   │   ├── main.tf
│   │   └── s3_bucket_policy.json
│   └── vpc
│       ├── interface.tf
│       └── main.tf
├── README.md
├── static_website
│   ├── 404.html
│   ├── create_static_website.sh
│   ├── file.out
│   ├── index.html
│   ├── main.tf
│   ├── terraform.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
├── vpc
│   ├── exec_create_vpc.sh
│   ├── file.out
│   ├── main.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── variables.tf
└── workspace.code-workspace



------------------------
Running the tests
---------------------
There are three directories, one for each test. To execute terraform test you need to CD into them.

--> vpc

    exec_create_vpc.sh --> shell script to create the VPC required by the test

static_website

    exec_create_static_website.sh  --> shell script to create the example static website on AWS S3

 Results:  if everything is right, you should see the output for cloudfront endpoint ie:

     cdn_domain_name = d1m3j4dtfb09ti.cloudfront.net

fargate

   exec_create_fargate.sh  --> shell script to bootstrap ECS Fargate with a nginx sample container

   Results: if everything is fine, you'll get the cluster endpoint for that task. ie:

    | Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    |
    | Outputs:
    |
    | ecs_service_endpoint = ecs-alb-346685991.us-east-1.elb.amazonaws.com

---------------
Branch "etapa2"
----------------

That branch has the changes proposed by "etapa2"

Those shell scripts have to be executed again to changes take effect.

 

Any question, please contact me by e-mail.

Thanks.

