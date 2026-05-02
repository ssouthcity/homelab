.PHONY: all
all: up

.PHONY: up
up: cluster-up flux-push flux-up

.PHONY: down
down: cluster-down

.PHONY: sync
sync: flux-push flux-sync

cluster-up:
	./scripts/kind-up.sh

cluster-down:
	./scripts/kind-down.sh

flux-push:
	./scripts/flux-push.sh

flux-up:
	./scripts/flux-up.sh

flux-sync:
	./scripts/flux-sync.sh
