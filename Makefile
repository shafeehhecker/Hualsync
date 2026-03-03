.PHONY: up down build logs migrate seed reset shell-backend shell-db backup

# Start all services
up:
	docker compose up -d

# Stop all services
down:
	docker compose down

# Rebuild and start
build:
	docker compose build && docker compose up -d

# View logs
logs:
	docker compose logs -f

# Run DB migrations
migrate:
	docker compose exec backend npx prisma migrate deploy

# Seed demo data
seed:
	docker compose exec backend node prisma/seed.js

# Migrate + seed in one step
init: migrate seed

# Full reset (WARNING: deletes all data)
reset:
	docker compose down -v
	docker compose up -d
	sleep 5
	$(MAKE) init

# Open backend shell
shell-backend:
	docker compose exec backend sh

# Open Postgres shell
shell-db:
	docker compose exec postgres psql -U haulsync haulsync

# Backup database
backup:
	docker compose exec postgres pg_dump -U haulsync haulsync > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "✅ Backup saved"

# Prisma Studio (DB GUI)
studio:
	cd backend && npx prisma studio
