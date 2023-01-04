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
        lsb-release \
        software-properties-common

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

RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list' \
    && apt-get -y update \
    && apt-get install -y \
        php-pear \
        php8.2 \
        php8.2-dev \
        php8.2-mbstring \
        php8.2-xml \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && mv composer.phar /usr/bin/composer \
    && php -r "unlink('composer-setup.php');"

# VS Code Extensions
RUN wget https://open-vsx.org/api/hashicorp/terraform/linux-x64/2.25.2/file/hashicorp.terraform-2.25.2@linux-x64.vsix \
    && unzip hashicorp.terraform-2.25.2@linux-x64.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/terraform

RUN wget https://open-vsx.org/api/bmewburn/vscode-intelephense-client/1.8.2/file/bmewburn.vscode-intelephense-client-1.8.2.vsix \
    && unzip bmewburn.vscode-intelephense-client-1.8.2.vsix "extension/*" \
    && mv extension /opt/code-oss/extensions/vscode-intelephense-client

COPY 300_copy_user_settings.sh /etc/workstation-startup.d/

RUN apt-get clean
