# cf. https://gallery.ecr.aws/amazonlinux/amazonlinux
# cf. https://dev.classmethod.jp/articles/tips-for-aws-cli-v2-on-container/
FROM public.ecr.aws/amazonlinux/amazonlinux:2

ENV TFLINT_VER 0.45.0
ENV TFLINT_RULE_SET_AWS_VER=0.21.2
ENV TFSEC_VERSION 1.28.1

# install awscli
RUN yum update -y && yum install -y \
  unzip \
  less \
  git \
  wget \
  tar \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install

# Install tfenv
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv \
  && ln -s ~/.tfenv/bin/* /usr/local/bin

# Install tflint
RUN curl --fail --silent -L -o /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VER}/tflint_linux_arm64.zip && \
    unzip /tmp/tflint.zip -d /tmp/ && \
    install -c -v /tmp/tflint /usr/local/bin/ && \
    rm /tmp/tflint*

# tflint rule
RUN mkdir -p  ~/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-aws/${TFLINT_RULE_SET_AWS_VER}/ && \
    curl --fail --silent -L -o /tmp/tflint-ruleset-aws.zip https://github.com/terraform-linters/tflint-ruleset-aws/releases/download/v${TFLINT_RULE_SET_AWS_VER}/tflint-ruleset-aws_linux_amd64.zip && \
    unzip /tmp/tflint-ruleset-aws.zip -d ~/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-aws/${TFLINT_RULE_SET_AWS_VER}/ && \
    rm /tmp/tflint-ruleset-aws.zip

# Install tfsec
# cf. https://docs.aws.amazon.com/ja_jp/prescriptive-guidance/latest/patterns/create-a-ci-cd-pipeline-to-validate-terraform-configurations-by-using-aws-codepipeline.html
RUN wget -q -O tfsec https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-arm64 \
  && chmod +x tfsec \
  && mv tfsec /usr/local/bin/

# tfcmt
# cf. https://techblog.szksh.cloud/fork-tfnotify/
ENV TFCMT_VER=4.2.0
RUN wget -q -O tfcmt.tar.gz https://github.com/suzuki-shunsuke/tfcmt/releases/download/v${TFCMT_VER}/tfcmt_linux_arm64.tar.gz \
  && tar -C /usr/bin -xzf ./tfcmt.tar.gz

# tfupdate
ENV TFUPDATE_VER=0.6.7
RUN wget -q -O tfupdate.tar.gz https://github.com/minamijoyo/tfupdate/releases/download/v${TFUPDATE_VER}/tfupdate_${TFUPDATE_VER}_linux_arm64.tar.gz \
  && tar -C /usr/bin -xzf ./tfupdate.tar.gz
