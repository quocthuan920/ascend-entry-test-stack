define checkoutRepository
	$(eval $@_REPO = $(1))
	$(eval $@_TARGET = $(2))
	$(eval $@_BRANCH = $(3))
	@if [ ! -d ./${$@_TARGET} ]; then \
		echo "==== Starting clone ${$@_REPO} into ${$@_TARGET} ===="; \
		git clone --branch ${$@_BRANCH} https://github.com/${$@_REPO}.git ./${$@_TARGET}; \
	else \
		echo "Pull the latest code into the "./${$@_TARGET}" folder..."; \
		cd ./${$@_TARGET}; \
		git pull; \
		cd ..; \
	fi
endef

init: create-nw checkout
create-nw:
	docker network ls | grep ascend-stack > /dev/null || docker network create ascend-stack

checkout:
	@echo "checkout Ascend project ...";
	@$(call checkoutRepository, "quocthuan920/ascend-entry-test", "ascend-entry-test", "master");

dev: docker-compose.dev.yml
	docker compose -f ./docker-compose.dev.yml down && docker compose -f ./docker-compose.dev.yml up --build -d
	