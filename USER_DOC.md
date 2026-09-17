# User Documentation

This document explains how an end user or administrator can use and manage the Inception project infrastructure.

## 1. Services provided by the stack
This infrastructure deploys a fully functional, containerized web environment containing the following core services:
*   **NGINX:** The sole entry point to the infrastructure, strictly handling secure TLSv1.2/TLSv1.3 traffic on port 443.
*   **WordPress:** The core Content Management System (CMS) served via PHP-FPM.
*   **MariaDB:** The relational database backend used to store WordPress data.
*   **Bonus Services:** The stack may also include Redis (caching), FTP (file transfer), a Static Website, Adminer (database management), and Portainer (container UI management).

## 2. Start and stop the project
You can easily manage the lifecycle of the project using the `Makefile` located at the root of the repository:
*   **Start the project:** Run `make all` to build the images and launch the containers in the background.
*   **Stop the project:** Run `make down` to gracefully stop the containers without losing data.
*   **Reset the project:** Run `make fclean` to stop containers, remove images, and permanently wipe all persistent volume data.

## 3. Access the website and the administration panel
Before accessing the site, ensure your local machine's `/etc/hosts` file maps `opernod.42.fr` to `127.0.0.1`.
*   **Website:** Open a web browser and navigate to `https://opernod.42.fr`.
*   **Administration Panel:** Navigate to `https://opernod.42.fr/wp-admin` to access the WordPress backend. Log in using the administrator credentials.

## 4. Locate and manage credentials
For security reasons, no sensitive information is hardcoded into the project files.
*   **Environment Variables:** General configuration variables (such as the domain name and usernames) are stored in the hidden `srcs/.env` file.
*   **Passwords and Secrets:** Sensitive credentials are saved locally in the `secrets/` directory. You can manage passwords by editing files like `secrets/db_password.txt` and `secrets/db_root_password.txt` before building the project.

## 5. Check that the services are running correctly
To verify that all services are functioning properly:
*   Open a terminal and run `docker-compose -f srcs/docker-compose.yml ps` (or `docker ps`) to see the status of all running containers.
*   If installed, you can also use the Portainer graphical interface to monitor container health, logs, and resource usage.
