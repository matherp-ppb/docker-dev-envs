ARG ENV_ALPINE_VERSION
FROM alpine:${ENV_ALPINE_VERSION}

ARG ENV_AWS_CDK_VERSION
ARG ENV_GLIBC_VERSION

ENV ALPINE_VERSION=${ENV_ALPINE_VERSION}
ENV AWS_CDK_VERSION=${ENV_AWS_CDK_VERSION}
ENV GLIBC_VERSION=${ENV_GLIBC_VERSION}

RUN echo "Alpine: $(ALPINE_VERSION)" && \
    echo "CDK: $(AWS_CDK_VERSION)" && \
    echo "GLIBC: $(GLIBC_VERSION)"

RUN apk -v --no-cache --update add \
        nodejs \
        npm \
        python3 \
        py3-pip \
        ca-certificates \
        github-cli \
        groff \
        less \
        bash \
        binutils \
        make \
        curl \
        wget \
        zip \
        git \
        && \
    update-ca-certificates && \
    pip install yawsso && \
    npm install -g aws-cdk@${AWS_CDK_VERSION} cdk-assume-role-credential-plugin fs-extra chalk @aws-cdk/cloudformation-diff \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VERSION}.apk \
        glibc-bin-${GLIBC_VERSION}.apk \
        glibc-i18n-${GLIBC_VERSION}.apk \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm awscliv2.zip 

VOLUME [ "/root/.aws" ]
VOLUME [ "/opt/app" ]

# Allow for caching python modules
VOLUME ["/usr/lib/python3.8/site-packages/"]

WORKDIR /opt/app

CMD ["cdk", "--version"]
