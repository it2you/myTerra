SRC_FOLDER=/root/myTerra
APP_DIR=$(SRC_FOLDER)/myapp
ECR_URL_FILE=$(SRC_FOLDER)/ecr-url.txt
DOCKER_FOLDER=$(SRC_FOLDER)/Dockerfiles
SSH_KEY=id_rsa

check_clean:
	@echo -n "Are you sure you want to RESET clean? [y/N] " && read ans && [ "$${ans:-N}" = "y" ]

clean: 
	cd $(SRC_FOLDER)
	rm -f $(SSH_KEY)
	rm -f $(SSH_KEY).pub
	rm -f Dockerfile 
	rm -f aws_infrastructure.out
	rm -f $(ECR_URL_FILE)
	@echo -n "**** Clean complete ****\n"

clean_reset: check_clean clean
	rm -rf .terraform*
	rm -f alb.tf ecs.tf
	@echo -n "**** Clean Reset complete ****\n " 

build_image:
	cd $(SRC_FOLDER)
	cp $(DOCKER_FOLDER)/Dockerfile.rpm Dockerfile
	docker buildx build --platform linux/amd64 --load -t vanilla .
	rm -f Dockerfile
	cp $(DOCKER_FOLDER)/Dockerfile.myapp Dockerfile
	docker buildx build --platform linux/amd64 --load -t myapp .

$(SSH_KEY):
	cd $(SRC_FOLDER)
	ssh-keygen -q -N "" -f $(SSH_KEY)
	chmod -c 0600 $(SSH_KEY)

ssh_key: $(SSH_KEY)

#deploy infrastrucrure in AWS 
aws_base_infrastructure: ssh_key
		cd $(SRC_FOLDER)
		terraform init && terraform plan -out aws_infrastructure.out && terraform apply -auto-approve
#		terraform plan | grep repository_base_url | sed -e "s/.*repository_base_url.*\"\(.*\)\"/\1/" >$(ECR_URL_FILE)

pushimage:
		cd $(SRC_FOLDER)
		$(eval REPO_URL := $(shell cat ${ECR_URL_FILE}))
		#tag image 
		docker tag myapp $(REPO_URL) 
		#authenticate image repo
		$(eval REPO_ID := $(shell cat ${ECR_URL_FILE}|cut -d'/' -f1 ))
		aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $(REPO_ID)
		docker push $(REPO_URL):latest

aws_ecs_infrastructure:
		cd $(SRC_FOLDER)
		#Copy configurations and deploy Load Balansing and ECS 
		cp  temporary_out_of_action/alb.tf temporary_out_of_action/ecs.tf .
		terraform init && terraform plan -out aws_infrastructure.out && terraform apply -auto-approve

deploy_all:	
		$(MAKE) build_image
	        $(MAKE) aws_base_infrastructure
		$(MAKE) pushimage
		$(MAKE) aws_ecs_infrastructure

destroy_all: 
		cd $(SRC_FOLDER)
		terraform init && terraform destroy -auto-approve
		$(MAKE) clean
		#NOTE: use clean_reset only when you sure no more infrastructure left and normal deployment went well
