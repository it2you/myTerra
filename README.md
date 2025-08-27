# Global 360 - HR Demo
# Cloud Infrastructure Engineer

## Video Of Deployment:
    https://it2you.com.au/Global360

## GitHub Repository:
    https://github.com/it2you/myTerra

## Prerequisite
    My Prerequisits : 
        1. LXC container with docker
        2. libraries to run Makefile 
            1. Ubuntu : apt-get install build-essential
            2. AWSLinux: yum install make
        3. awscli package 
        4. Git binaries 

## Install dependencies
    ### Setup aws credentials

    export AWS_SECRET_ACCESS_KEY=****
    export AWS_ACCESS_KEY_ID=****
    
    run:
        aws configure 
    Clone project:
        git clone https://github.com/it2you/myTerra
    

## Project directory structure
    See video for details
    ├── Dockerfiles - different Dockerfiles 
    ├── myapp - php application 
    │   ├── app
    │   ├── bootstrap
    │   ├── config
    │   ├── database
    │   ├── laravel
    │   ├── public
    │   ├── resources
    │   ├── routes
    │   ├── run_env
    │   ├── screenshots
    │   ├── storage
    │   ├── tests
    │   └── vendor
    └── temporary_out_of_action - some terraform files for staged deployment 

See video for details

## Build project

    There are following targets :

    1. clean - for use with destroy_all
    2. build_image
    3. ssh_key
    4. aws_infrastructure
    5. pushimage
    6. aws_ecr
    7. destroy_all


## Run Install 
    
    make deploy_all

## Uninstall 
    make destroy_all

