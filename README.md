# setup for local environment #

```
* `make init`: check out all repositories and create network
========================

## After checkout all repository, run the following commands:
* `make dev`: run all containers for development
```

# IF NOT USE GNU MAKE #
From here:

- git clone https://github.com/quocthuan920/ascend-entry-test.git
- cd ./ascend-entry-test
- npm install 
- cp ./.env.local ./.env
- cp ./id_rsa_priv_local.pem ./id_rsa_priv.pem
- docker network ls | grep ascend-stack > /dev/null || docker network create ascend-stack
- cd ../
- docker compose -f ./docker-compose.dev.yml down && docker compose -f ./docker-compose.dev.yml up --build -d

# URL #
- Server run at: http://localhost:8000
- Swagger: http://localhost:8000/docs/dlZwSzZJKnmhc2iMv0AqBD79NV3FsjhoWjWDbQOacO7M
