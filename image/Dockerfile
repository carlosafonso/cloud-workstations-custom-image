FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Use ARG instead of ENV, as using ENV pollutes images based on this one
# whereas ARG only applies during build time.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
    && apt-get install -y \
        apt-transport-https \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        gnupg \
        jq \
        lsb-release \
        software-properties-common

# Docker Compose
RUN apt-get -y install docker-compose-plugin

# K8s tooling: Kubectx
RUN wget -O- https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx_v0.9.5_linux_x86_64.tar.gz | tar -xvz kubectx \
    && chmod +x kubectx \
    && mv kubectx /usr/bin

# K8s tooling: K9s
RUN wget -O- https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_amd64.tar.gz | tar -xvz k9s \
    && chmod +x k9s \
    && mv k9s /usr/bin

# Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get -y update \
    && apt-get -y install terraform

# PHP 8.2 additional extensions and libraries
RUN add-apt-repository -y ppa:ondrej/php \
    && apt-get install -y \
        php-pear \
        php8.2 \
        php8.2-dev \
        php8.2-mbstring \
        php8.2-xml \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && php -r "unlink('composer-setup.php');"

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# AWS SAM
RUN curl -LO "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" \
    && unzip aws-sam-cli-linux-x86_64.zip -d sam-installation \
    && ./sam-installation/install \
    && sam --version \
    && rm -rf aws-sam-cli-linux-x86_64.zip sam-installation

# VS Code Extensions
RUN wget https://open-vsx.org/api/hashicorp/terraform/linux-x64/2.25.2/file/hashicorp.terraform-2.25.2@linux-x64.vsix \
    && unzip hashicorp.terraform-2.25.2@linux-x64.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/terraform

RUN wget https://open-vsx.org/api/bmewburn/vscode-intelephense-client/1.8.2/file/bmewburn.vscode-intelephense-client-1.8.2.vsix \
    && unzip bmewburn.vscode-intelephense-client-1.8.2.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/vscode-intelephense-client

RUN wget https://open-vsx.org/api/ms-python/python/2023.2.0/file/ms-python.python-2023.2.0.vsix \
    && unzip ms-python.python-2023.2.0.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/python

RUN wget https://open-vsx.org/api/Vue/volar/1.2.0/file/Vue.volar-1.2.0.vsix \
    && unzip Vue.volar-1.2.0.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/Vue.volar-1.2.0

# User scripts
COPY 300_copy_user_settings.sh /etc/workstation-startup.d/

RUN apt-get clean
