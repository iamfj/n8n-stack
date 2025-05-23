dev_files := "-f compose.yml -f compose.dev.yml"
prod_files := "-f compose.yml -f compose.dev.yml -f compose.prod.yml"

default:
    @just --list --list-heading $'Available commands:\n'

up env="dev" rebuild="rebuild":
    docker compose {{ if env == "prod" { prod_files } else { dev_files } }} up --detach --wait {{ if rebuild == "rebuild" { "--build" } else { "" } }}

down env="dev":
    docker compose {{ if env == "prod" { prod_files } else { dev_files } }} down --remove-orphans

pull env="dev":
    docker compose {{ if env == "prod" { prod_files } else { dev_files } }} pull

logs service:
    docker compose {{ prod_files }} logs -f {{service}}

[confirm('Are you sure you want to clean the environment? (y/n)')]
clean env="dev":
    docker compose {{ if env == "prod" { prod_files } else { dev_files } }} down --volumes --rmi all --remove-orphans

alias start := up
alias stop := down

restart env="dev": (down env) && (up env)

[confirm('The stack will be updated and restarted. Are you sure you want to continue? (y/n)')]
update env="dev": (down env) (pull env) && (up env "rebuild")
