FROM alpine:3.24.3

ARG USER_NAME=claude
ARG CLAUDE_DOWNLOADS_URL=https://downloads.claude.ai
ARG NGROK_DOWNLOADS_URL=https://bin.equinox.io/c/bNyj1mQVY4c
ARG UV_INSTALL_URL=https://astral.sh/uv/install.sh
ARG TARGETARCH

ENV PYTHONUNBUFFERED=1 \
    SHELL=/bin/bash

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    wget -qO /etc/apk/keys/claude-code.rsa.pub "${CLAUDE_DOWNLOADS_URL}/keys/claude-code.rsa.pub" \
    && echo "${CLAUDE_DOWNLOADS_URL}/claude-code/apk/stable" >> /etc/apk/repositories \
    && apk add --upgrade \
        bash \
        claude-code \
        doas \
        git \
        nodejs \
        npm \
        python3 \
        py3-pip \
    && adduser -D -s /bin/bash "${USER_NAME}" \
    && adduser "${USER_NAME}" wheel \
    && echo 'permit nopass :wheel' > /etc/doas.d/doas.conf \
    && install -d -o "${USER_NAME}" -g "${USER_NAME}" "/home/${USER_NAME}/.claude"

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"

RUN wget -qO- "${UV_INSTALL_URL}" | sh \
    && wget -qO- "${NGROK_DOWNLOADS_URL}/ngrok-v3-stable-linux-${TARGETARCH}.tgz" \
        | tar -xz -C "${HOME}/.local/bin" \
    && uv tool install graphifyy \
    && graphify install

VOLUME ["/home/${USER_NAME}/.claude"]