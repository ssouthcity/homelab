
.PHONY: bootstrap
bootstrap:
	k3sup install \
		--host "192.168.10.161" \
		--user "homelab" \
		--ssh-key "$(HOME)/.ssh/id_ed25519" \
		--local-path "$(HOME)/.kube/config" \
		--context "homelab"
