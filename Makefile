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

define copyFileIfNotExist
    $(eval $@_REPO = $(1))
    $(eval $@_TARGET = $(2))
    $(eval $@_FROM = $(3))
    @if [ ! -f ./${$@_REPO}/${$@_TARGET} ]; then \
        echo "==== Creating file ${$@_TARGET} from ${$@_FROM} in ${$@_REPO} ===="; \
        cp ./${$@_REPO}/${$@_FROM} ./${$@_REPO}/${$@_TARGET}; \
    else \
        echo "File ${$@_TARGET} already exists in ${$@_REPO}"; \
    fi
endef

define installNodeModulesIfNotExist
    $(eval $@_REPO = $(1))
    @if [ ! -d ./${$@_REPO}/node_modules ]; then \
        echo "==== Installing node_modules in ${$@_REPO} ===="; \
        cd ./${$@_REPO} && npm install; \
    else \
        echo "node_modules already exists in ${$@_REPO}"; \
    fi
endef

init: create-nw checkout
create-nw:
	docker network ls | grep ascend-stack > /dev/null || docker network create ascend-stack

checkout:
	@echo "checkout Ascend project ...";
	@$(call checkoutRepository, "quocthuan920/ascend-entry-test", "ascend-entry-test", "master");

dev: docker-compose.dev.yml
	@$(call copyFileIfNotExist, "ascend-entry-test", ".env", ".env.local");
	@$(call copyFileIfNotExist, "ascend-entry-test", "id_rsa_priv.pem", "id_rsa_priv_local.pem");
	@$(call installNodeModulesIfNotExist, "ascend-entry-test")
	docker compose -f ./docker-compose.dev.yml down && docker compose -f ./docker-compose.dev.yml up --build -d