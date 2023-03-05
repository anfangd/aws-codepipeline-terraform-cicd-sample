#  aws-codepipeline-terraform-cicd-sample
  
  
![](./docs/img/concept.drawio.svg )
  
##  Terraform Resource Architecture | Terraform Deployment Pipeline
  
  
![](./docs/img/ModuleRelationshipDiagram.drawio.svg )
  
##  Docker Image for CodeBuld
  
  
```sh
# 1. Retrieve an authentication token and authenticate your Docker client to your registry.
aws ecr get-login-password --region ${AWS_REGION} \
  | docker login \
    --username AWS -\
    -password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com
  
# 2. Build your Docker image using the following command.
docker build -t ${ECR_REPOSITORY_NAME} .
  
# 3. After the build completes, tag your image so you can push the image to target repository:
docker tag terraform:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest
  
# 4. Run the following command to push this image to your newly created AWS repository:
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest
```
  
```sh
# FOR DEBUG
docker run --rm --name ${CONTAINER_NAME} -it ${IMAGE_NAME} /bin/bash
```
  
##  VSCode Settings
  
  
##  VSCode Extensions
  
  
  