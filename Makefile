SRC_FOLDER=/root/myTerra
APP_DIR=$(SRC_FOLDER)/myapp

ECR_URL_FILE=$(SRC_FOLDER)/ecr-url.txt
SSH_KEY=id_rsa
DOCKER_FOLDER=$(SRC_FOLDER)/Dockerfiles

clean:
	cd $(SRC_FOLDER)
	rm $(SSH_KEY)
	rm $(SSH_KEY).pub
	rm -rf .terraform*
	rm Dockerfile
	aws_infrastructure.out
	rm $(ECR_URL_FILE)

#_%.test:
#	cd $* && python3 -m pip install -r requirements.txt && python3 -m pytest

#$(BUILD_DIR):
#	mkdir -p $(BUILD_DIR)

build_image:
	cd $(SRC_FOLDER)
	cp $(DOCKER_FOLDER)/Dockerfile.rpm Dockerfile
	docker buildx build --platform linux/amd64 --load -t vanilla .
	rm Dockerfile
	cp $(DOCKER_FOLDER)/Dockerfile.myapp Dockerfile
	docker buildx build --platform linux/amd64 --load -t myapp .

#docker:
#	$(eval IMAGE_NAME = $(subst -,_,$*))
#	cd $* && docker buildx build --platform linux/amd64 --load -t $(IMAGE_NAME) .


$(SSH_KEY):
	cd $(SRC_FOLDER)
	ssh-keygen -q -N "" -f $(SSH_KEY)
	chmod -c 0600 $(SSH_KEY)

ssh_key: $(SSH_KEY)

aws_infrastructure: ssh_key
		cd $(SRC_FOLDER)
		terraform init && terraform plan -out aws_infrastructure.out && terraform apply -auto-approve
#		terraform plan | grep repository_base_url | sed -e "s/.*repository_base_url.*\"\(.*\)\"/\1/" >$(ECR_URL_FILE)
#		tag image 

pushimage:
		cd $(SRC_FOLDER)
		$(eval REPO_URL := $(shell cat ${ECR_URL_FILE}))
		docker tag myapp $(REPO_URL) 
#		authenticate image repo
		$(eval REPO_ID := $(shell cat ${ECR_URL_FILE}|cut -d'/' -f1 ))
		aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $(REPO_ID)
		docker push $(REPO_URL):latest


#terraform apply -auto-approve

aws_ecr:
	cd $(SRC_FOLDER)
	cp  temporary_out_of_action/alb.tf temporary_out_of_action/ecs.tf .




_%.deinfra: ssh_key
	cd infra/$* && terraform init && terraform destroy -auto-approve

%.deinfra:
	dojo "make _$*.deinfra"

_deploy_site:
	cd build &&\
	mkdir -p static &&\
	cd static &&\
	tar xf ../static.tgz &&\
	aws s3 sync . s3://news$$(cat ../../interview_id.txt)-terraform-infra-static-pages/static/

deploy_site:
	dojo "make _deploy_site"

# Interview time:

deploy_interview:
	$(MAKE) clean
	$(MAKE) static
	$(MAKE) backend-support.infra
	$(MAKE) base.infra
	$(MAKE) docker # builds all images
	$(MAKE) push
	$(MAKE) news.infra
	$(MAKE) deploy_site

destroy_interview:
	$(MAKE) news.deinfra
	$(MAKE) base.deinfra
	$(MAKE) backend-support.deinfra
