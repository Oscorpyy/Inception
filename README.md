*This project has been created as part of the 42 curriculum by opernod.*

# Inception

## Description
Inception is a system administration project designed to broaden our knowledge of infrastructure and containerization. The main goal is to deploy a complete, secure web infrastructure using Docker and Docker Compose inside a Virtual Machine. 

To simulate a real-world production environment, each service runs in its own dedicated container built from a custom Dockerfile based on Debian Bullseye. The project strictly prohibits ready-made images, enforces secure TLS communication (NGINX), and requires proper data persistence.

### Architectural & Design Choices
*   **Operating System:** All containers are built from Debian Bullseye.
*   **Single Entrypoint:** NGINX is the only entry point to the infrastructure, strictly handling TLSv1.2 or TLSv1.3 traffic on port 443.
*   **Security:** Passwords and API keys are strictly managed via Docker Secrets and local environment variables `.env`, never hardcoded in Dockerfiles.
*   **Process Management:** No `tail -f` or infinite loop hacks are used; services run in the foreground naturally.

### Technical Comparisons

*   **Virtual Machines vs Docker:**
    A Virtual Machine (VM) emulates an entire physical computer, including a full guest Operating System and hardware stack. This makes VMs heavy and resource-intensive. Docker, on the other hand, is a containerization platform. Containers share the host system's OS kernel and only package the application code and its specific dependencies. This makes Docker containers significantly lighter, faster to start, and more efficient in resource consumption.

*   **Secrets vs Environment Variables:**
    Environment variables are often used for configuration but can be easily exposed (e.g., via `docker inspect`, application crash logs, or the `env` command). Docker Secrets provide a much safer alternative for sensitive data (like database passwords). Secrets are securely transmitted and mounted in memory (`/run/secrets/`) within the container, preventing them from being leaked in standard logs or easily accessed by unauthorized processes.

*   **Docker Network vs Host Network:**
    Using a Host Network (`network_mode: host`) binds a container directly to the host machine's network interfaces, bypassing Docker's network isolation. This can lead to port conflicts and security risks. A Docker Network (like a custom `bridge` network) creates an isolated, internal network namespace where containers can securely communicate with each other using internal DNS resolution (their container names), exposing only strictly necessary ports to the outside world.

*   **Docker Volumes vs Bind Mounts:**
    Bind Mounts map a very specific file or directory from the host machine directly into the container. They heavily rely on the host system's file structure and permissions. Docker Volumes, however, are entirely managed by Docker within a dedicated host directory. Volumes are easier to back up, migrate, and manage across different operating systems. In this project, we specifically use the `local` volume driver to enforce data storage in a specific path (`/home/opernod/data/`) as required by the assignment constraints.

## Instructions

### 1. Prerequisites
Ensure Docker and Docker Compose are installed on your Virtual Machine. 
You must map the local domain name to your loopback address. Open your `/etc/hosts` file and add the following line:
```text
127.0.0.1 opernod.42.fr
```

### 2. Credentials Setup
Before building the project, create the mandatory secrets files in the `./secrets/` directory to securely store your passwords. The `.env` file must also be present in the `./srcs/` directory.
Required secret files:
*   `./secrets/db_password.txt`
*   `./secrets/db_root_password.txt`
*(If you have configured the Portainer bonus, add your `portainer_password.txt` here as well).*

### 3. Build and Execution
Navigate to the root of the repository and use the provided `Makefile` to manage the infrastructure:
*   **Build and start the infrastructure:**
    ```bash
    make
    ```
*   **Stop the containers gracefully:**
    ```bash
    make down
    ```
*   **Clean up containers, images, and networks:**
    ```bash
    make clean
    ```
*   **Complete wipe (Removes containers, images, and strictly deletes all persistent volume data):**
    ```bash
    make fclean
    ```
*   **Rebuild from scratch:**
    ```bash
    make re
    ```

## Resources
*   **Docker Official Documentation:** [docs.docker.com](https://docs.docker.com/)
*   **NGINX Reverse Proxy & TLS Configuration:** [nginx.org/en/docs/](https://nginx.org/en/docs/)
*   **WordPress CLI (WP-CLI):** [developer.wordpress.org/cli/commands/](https://developer.wordpress.org/cli/commands/)
*   **MariaDB Documentation:** [mariadb.com/kb/en/](https://mariadb.com/kb/en/)

### AI Usage
Artificial Intelligence was utilized:
- To verify Dockerfile security practices (ensuring correct permissions and eliminating hacky daemon patches)
- To help structure the documentation to strictly comply with the project's strict guidelines.
- To help to explain the goal of the project and how to do it
