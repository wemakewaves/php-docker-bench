CONCURRENCY ?= 100
REPS ?= 100

.PHONY: bench_all bench_official-fpm bench_official-apache bench_custom-fpm

bench_all: bench_official-fpm bench_official-apache bench_custom-fpm

bench_official-fpm:
	@docker-compose -f docker-compose.official-fpm.yaml -p php_bench_official_fpm down
	@docker-compose -f docker-compose.official-fpm.yaml -p php_bench_official_fpm build
	@docker-compose -f docker-compose.official-fpm.yaml -p php_bench_official_fpm up -d
	@echo ""
	@echo "Official php-fpm + nginx"
	@echo ""
	sleep 3;
	siege -b -c${CONCURRENCY} -r${REPS} http://127.0.0.1/lucky/number
	@docker-compose -f docker-compose.official-fpm.yaml -p php_bench_official_fpm down

bench_official-apache:
	@docker-compose -f docker-compose.official-apache.yaml -p php_bench_official_apache down
	@docker-compose -f docker-compose.official-apache.yaml -p php_bench_official_apache build
	@docker-compose -f docker-compose.official-apache.yaml -p php_bench_official_apache up -d
	@echo ""
	@echo "Official mod_php + apache"
	@echo ""
	sleep 3;
	siege -b -c${CONCURRENCY} -r${REPS} http://127.0.0.1/lucky/number
	@docker-compose -f docker-compose.official-apache.yaml -p php_bench_official_apache down

bench_custom-fpm:
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm down
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm build
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm up -d
	@echo ""
	@echo "Custom php-fpm + nginx"
	@echo ""
	sleep 3;
	siege -b -c${CONCURRENCY} -r${REPS} http://127.0.0.1/lucky/number
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm down

install:
	@docker run --rm \
	--volume ${CURDIR}/symfony_skeleton:/app \
	composer install --ansi
