FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

RUN apt-get -y update \
    && apt-get install -y build-essential gnupg lsb-release software-properties-common \
    && apt-get clean

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
    && apt-get -y install terraform \
    && apt-get clean
