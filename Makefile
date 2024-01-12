build:
	docker build . -t sites

start:
	kubectl apply -k kustomize/dev

delete:
	kubectl delete -k kustomize/dev

psql:
	kubectl exec -it deploy/dev-postgresql -- psql -U postgres

shell:
	kubectl exec -it deployments/dev-sites -- iex -S mix

local-db-reset:
	kubectl exec -it deployments/dev-sites -- mix ecto.reset

clean:
	todo	