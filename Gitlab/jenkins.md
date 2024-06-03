To add the timezone configuration to the container, you can set the timezone inside the Dockerfile. Here's the updated process including setting the timezone to Europe/Helsinki.

### Step 1: Backup Your Existing Jenkins Configuration
Ensure you have a backup of your current Jenkins configuration and jobs. This can be done by copying the Jenkins home directory, typically located at `/var/lib/jenkins`.

1. **Backup Jenkins Home Directory:**
    ```bash
    sudo cp -r /var/lib/jenkins /var/lib/jenkins_backup
    ```

### Step 2: Create a Dockerfile for Jenkins
Create a Dockerfile to build a container image for Jenkins using Podman. Include the timezone configuration.

1. **Create a Dockerfile:**
    ```Dockerfile
    # Use the official Jenkins LTS image
    FROM jenkins/jenkins:lts

    # Set the timezone to Europe/Helsinki
    RUN apt-get update && \
        apt-get install -y tzdata && \
        ln -fs /usr/share/zoneinfo/Europe/Helsinki /etc/localtime && \
        dpkg-reconfigure -f noninteractive tzdata

    # Copy Jenkins configuration and jobs
    COPY jenkins_backup /var/jenkins_home

    # Set environment variables (if needed)
    ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
    
    # Expose Jenkins port
    EXPOSE 8080
    ```

### Step 3: Copy Your Jenkins Backup to the Podman Context
Ensure your `jenkins_backup` directory is in the same directory as your Dockerfile or adjust the Dockerfile to point to the correct location.

### Step 4: Build the Container Image
Navigate to the directory containing your Dockerfile and build the container image using Podman.

1. **Build Podman Image:**
    ```bash
    podman build -t my-jenkins:latest .
    ```

### Step 5: Run the Container with SELinux Options
When running the container, use SELinux options to ensure compatibility.

1. **Run Podman Container with SELinux:**
    ```bash
    podman run -d -p 8080:8080 -p 50000:50000 --name my-jenkins-container -v jenkins_home:/var/jenkins_home:Z my-jenkins:latest
    ```
    The `:Z` option relabels the volume to match the container's SELinux policy.

### Step 6: Verify Jenkins is Running
Open a web browser and navigate to `http://localhost:8080`. You should see your Jenkins instance running with all the configurations and jobs intact.

### Additional Steps (Optional)
- **Persisting Data:** Ensure your Jenkins data persists even after container restarts. This is already handled with the `:Z` option for SELinux compatibility.

- **Customizing Jenkins Configuration:** Modify the Jenkins configuration (e.g., plugins, security settings) directly in the Dockerfile or through initialization scripts.

### Step 7: Automate with Podman Compose (Optional)
Automate the setup using Podman Compose with SELinux options.

1. **Create a `podman-compose.yml` file:**
    ```yaml
    version: '3.8'
    services:
      jenkins:
        image: my-jenkins:latest
        ports:
          - "8080:8080"
          - "50000:50000"
        volumes:
          - jenkins_home:/var/jenkins_home:Z

    volumes:
      jenkins_home:
    ```

2. **Run Podman Compose:**
    ```bash
    podman-compose up -d
    ```

### Ensuring SELinux Contexts are Correct
After running your container, you might want to verify the SELinux contexts to ensure everything is correctly labeled.

1. **Check SELinux Contexts:**
    ```bash
    ls -lZ /var/lib/jenkins_home
    ```

2. **Relabel if Necessary:**
    ```bash
    sudo chcon -R -t container_file_t /var/lib/jenkins_home
    ```

By following these steps, you can containerize your Jenkins setup using Podman, set the timezone to Europe/Helsinki, and ensure compatibility with SELinux, maintaining a secure and correctly configured environment.