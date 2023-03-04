# cf. https://gallery.ecr.aws/amazonlinux/amazonlinux
# cf. https://dev.classmethod.jp/articles/tips-for-aws-cli-v2-on-container/
FROM public.ecr.aws/amazonlinux/amazonlinux:2

ENV TERRAFORM_VERSION 1.3.9
# ENV TFLINT_VER 0.45.0
ENV TFLINT_RULE_SET_AWS_VER=0.21.2
ENV TFSEC_VERSION 1.28.1

# install awscli
RUN yum update -y && yum install -y \
  unzip \
  less \
  git \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install

# Install Terraform
# RUN cd /usr/local/bin && \
#   curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
#   unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
#   rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install tfenv
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
  && ln -s ~/.tfenv/bin/* /usr/local/bin

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# tflint rule
RUN mkdir -p  ~/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-aws/${TFLINT_RULE_SET_AWS_VER}/ && \
    curl --fail --silent -L -o /tmp/tflint-ruleset-aws.zip https://github.com/terraform-linters/tflint-ruleset-aws/releases/download/v${TFLINT_RULE_SET_AWS_VER}/tflint-ruleset-aws_linux_amd64.zip && \
    unzip /tmp/tflint-ruleset-aws.zip -d ~/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-aws/${TFLINT_RULE_SET_AWS_VER}/ && \
    rm /tmp/tflint-ruleset-aws.zip

# Install tfsec
RUN curl -Lso tfsec https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 \
  && chmod +x tfsec && mv tfsec /usr/local/bin/
