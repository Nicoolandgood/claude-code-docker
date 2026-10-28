FROM alpine:3.24.3

ENV PYTHONUNBUFFERED=1

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    wget -O /etc/apk/keys/claude-code.rsa.pub https://downloads.claude.ai/keys/claude-code.rsa.pub && \
    echo "https://downloads.claude.ai/claude-code/apk/stable" >> /etc/apk/repositories && \
    apk add --upgrade \
        claude-code \
        doas \
        git \
        bash \
        python3 \
        py3-pip \
    && \
    adduser claude -D && \
    echo 'permit nopass :wheel' > /etc/doas.d/doas.conf && \
	adduser claude wheel && \
	mkdir -p /home/claude/.claude && \
	chown -R 1000:1000 /home/claude/.claude

USER claude

ENV SHELL="/bin/bash"

RUN wget -qO- https://astral.sh/uv/install.sh | /bin/sh && \
    $HOME/.local/bin/uv tool update-shell && \
    $HOME/.local/bin/uv tool install graphifyy && \
    $HOME/.local/bin/graphify install

VOLUME [ "/home/claude/.claude" ]