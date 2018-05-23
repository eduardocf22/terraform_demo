Terraform Demo

Author: Rafael Nize
github: rafaelnize

This document follows the intructions sent by e-mail.

Getting Started

These instructions will get you a copy of the the project up and running on your local machine and AWS account. This software is for testing purposes. Its use on production is discouraged.


Prerequisites

Terraform
awscli 
AWS account


Installing

Make sure you have the awscli installed properly on you bastion host or workstation

If you don't have any aws credentials at ~/.aws/credentials you can create one using:

aws configure

make sure the current time and date in your workstation is correct otherwise, aws cli won't work properly.


Install Terraform

To install terraform, follow instructions at:
https://www.terraform.io/intro/getting-started/install.html

Make sure terraform binary is in your OS Path environment variable !

Check installation

execute the following command to make sure terraform runs fine:

terraform version



Running the tests

There are two directories, one for each test. To execute terraform test you need to CD into them.

vpc

    exec_create_vpc.sh --> shell script to create the VPC required by the test

static_website

    exec_create_static_website.sh  --> shell script to create the example static website on AWS S3




