# Developer Documentation

## 1. Setting up the environment from scratch
*   **Virtual Machine:** This project needs to be done on a Virtual Machine.
*   **Configuration Directory:** All the files required for the configuration of your project must be placed in a `srcs` folder.
*   **Environment Variables:** It is mandatory to use environment variables, and they must be stored in a `.env` file. You can store your variables (such as a domain name) in this file.
*   **Secrets Management:** It is strongly recommended that you use Docker secrets to store any confidential information. Any credentials, API keys, or passwords must be saved locally in various ways/files and ignored by git. You must create a `secrets/` directory containing files like `db_password.txt` and `db_root_password.txt`. No password must be present in your Dockerfiles.

## 2. Building and launching the project
*   **Makefile Location:** A Makefile is required and must be located at the root of your directory.
*   **Build Process:** The Makefile must set up your entire application, meaning it has to build the Docker images using `docker-compose.yml`. The Dockerfiles must be called in your `docker-compose.yml` by your Makefile, so you have to build the Docker images of your project yourself.
*   **Launch Command:** Run `make all` at the root of the repository to launch the configuration and execute `docker-compose up -d --build`.
*   **Stop Command:** Run `make down` to stop the containers using `docker-compose down`.
*   **Clean Command:** Run `make fclean` to clean up containers, images, networks, and perform a total deletion of the data folders.

## 3. Managing containers and volumes
*   **Container Architecture:** Each service has to run in a dedicated container. For performance reasons, the containers must be built either from the penultimate stable version of Alpine or Debian.
*   **Lifecycle and Entrypoints:** Your containers have to restart in case of a crash. Your containers must not be started with a command running an infinite loop. Hacky patches such as `tail -f`, `bash`, `sleep infinity`, and `while true` are prohibited.
*   **Network:** The `network` line must be present in your `docker-compose.yml` file. Using `network: host` or `--link` is forbidden.
*   **Useful Docker Commands:**
    *   Check container status: `docker compose -f srcs/docker-compose.yml ps`
    *   Inspect container logs: `docker logs <container_name>`
    *   Execute commands inside a container: `docker exec -it <container_name> sh`
    *   Manage volumes: `docker volume ls` and `docker volume inspect <volume_name>`

## 4. Data storage and persistence
*   **Persistence Method:** To ensure data persists even if containers are stopped or removed, the architecture utilizes local volumes mapped to the host machine.
*   **Database Storage:** The MariaDB data persists locally on the host machine in the `/home/opernod/data/mariadb/` directory.
*   **Website Storage:** The WordPress website files persist locally on the host machine in the `/home/opernod/data/wordpress/` directory.
*   **Data Wiping:** Running the `make fclean` command will intentionally execute `sudo rm -rf` on these specific host directories to completely wipe the persistent project data.
