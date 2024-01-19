build:
	docker build -f Dockerfile.multi . --build-arg MIX_ENV=dev --target dev -t sites-new

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

reset-db:
	kubectl exec -it deployments/dev-sites -- mix ecto.reset

reset:
	make delete
	make start