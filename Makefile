all:
	@printf "Lancement de la configuration Inception...\n"
	@docker-compose -f srcs/docker-compose.yml up -d --build

down:
	@printf "Arrêt des conteneurs...\n"
	@docker-compose -f srcs/docker-compose.yml down

re:
	@printf "Reconstruction de l'infrastructure...\n"
	@docker-compose -f srcs/docker-compose.yml up -d --build --force-recreate

clean:
	@printf "Nettoyage des conteneurs, images et réseaux...\n"
	@docker-compose -f srcs/docker-compose.yml down --rmi all -v

fclean: clean
	@printf "Suppression totale des volumes et des dossiers de données...\n"
	@sudo rm -rf /home/opernod/data/mariadb/*
	@sudo rm -rf /home/opernod/data/wordpress/*
	@docker system prune -af

.PHONY: all down re clean fclean
