build:
	docker build -f Dockerfile.multi . --build-arg MIX_ENV=dev --target dev -t sites-new

repo-init:
	brew update
	brew install kubectl
	brew install tilt
	kubectl create ns dev

kube-init:
	kubectl create ns dev

start:
	kubectl apply -k kustomize/dev

delete:
	kubectl delete -k kustomize/dev

psql:
	kubectl exec -it deploy/dev-postgresql -- psql -U postgres

iex:
	kubectl exec -it deployments/dev-sites -- iex -S mix

sh:
	kubectl exec -it deployments/dev-sites -- sh

db-create:
	kubectl exec -it deployments/dev-sites -- mix ecto.setup

db-reset:
	kubectl exec -it deployments/dev-sites -- mix ecto.reset

reset:
	make delete
	make start