WORKDIR := /var/www/html

up-local: up-web-local create-system-dirs composer migration

create-system-dirs:
	docker exec php-container-local mkdir -p $(WORKDIR)/vendor
	docker exec php-container-local mkdir -p $(WORKDIR)/public/bundles
	docker exec php-container-local mkdir -p $(WORKDIR)/config/jwt
	docker exec php-container-local chown -R www-data:www-data $(WORKDIR)/vendor
	docker exec php-container-local chown -R www-data:www-data $(WORKDIR)/var
	docker exec php-container-local chown -R www-data:www-data $(WORKDIR)/public/bundles
	docker exec php-container-local chown -R www-data:www-data $(WORKDIR)/bin
	docker exec php-container-local chown -R www-data:www-data $(WORKDIR)/config/jwt

up-web-local:
	docker-compose -f .infrastructure/docker-compose.local.yml --env-file .env.local up -d --build

composer:
	docker exec --user www-data -t php-container-local bash -c 'COMPOSER_MEMORY_LIMIT=-1 composer install  --no-interaction'

migration:
	docker exec -it php-container-local bash -c 'bin/console --env=dev doctrine:migrations:migrate --no-interaction'

down-local:
	docker-compose -f .infrastructure/docker-compose.local.yml down

migrate:
	docker exec -it php php bin/console doctrine:migrations:migrate --no-interaction

bash:
	docker exec -it php bash
