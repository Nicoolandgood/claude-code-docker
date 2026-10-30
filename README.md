# Claude Code Docker

This is a small project creating a workspace for `claude-code` inside a Docker container.

## Usage
Start the container by running:
```sh
docker compose up -d
```

Then, access the container shell:
```sh
docker compose exec claude-code bash
```

You will end up in the `/workspace` directory, which is a volume on the host.
