all:
		@printf "Starting Inception configuration...\n"
		@sudo mkdir -p /home/opernod/data/mariadb /home/opernod/data/wordpress /home/opernod/data/portainer
		@docker compose -f srcs/docker-compose.yml up -d --build

down:
		@printf "Stopping containers...\n"
		@docker compose -f srcs/docker-compose.yml down

re:
		@printf "Rebuilding the infrastructure...\n"
		@sudo mkdir -p /home/opernod/data/mariadb /home/opernod/data/wordpress /home/opernod/data/portainer
		@docker compose -f srcs/docker-compose.yml up -d --build --force-recreate

clean:
		@printf "Cleaning up containers, images and networks...\n"
		@docker compose -f srcs/docker-compose.yml down --rmi all -v

fclean: clean
		@printf "Complete removal of volumes and data directories...\n"
		@sudo rm -rf /home/opernod/data/mariadb/*
		@sudo rm -rf /home/opernod/data/wordpress/*
		@sudo rm -rf /home/opernod/data/portainer/*
		@docker system prune -af

.PHONY: all down re clean fclean

