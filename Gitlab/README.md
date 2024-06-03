# Gitlab to Container


### Step 1: Backup Existing GitLab Data

1. **Stop GitLab Services**:
   ```sh
   sudo gitlab-ctl stop
   ```

2. **Create a Backup**:
   - Run the GitLab backup command to create a backup of your existing GitLab instance:
     ```sh
     sudo gitlab-rake gitlab:backup:create
     ```
   - The backup file will be stored in `/var/opt/gitlab/backups` by default. You can change this location by editing the GitLab configuration file (`/etc/gitlab/gitlab.rb`).

3. **Backup Configuration Files**:
   - Copy the GitLab configuration files to a safe location:
     ```sh
     sudo cp /etc/gitlab/gitlab.rb /etc/gitlab/gitlab-secrets.json /srv/gitlab/config/
     ```

### Step 2: Set Up Podman and Pull GitLab CE Image

1. **Install Podman**:
   Follow the installation instructions for your operating system from the [Podman installation guide](https://podman.io/getting-started/installation).

2. **Pull the Latest GitLab CE Image**:
   ```sh
   podman pull gitlab/gitlab-ce:latest
   ```

### Step 3: Prepare the Container Environment

1. **Create Configuration Directories**:
   ```sh
   mkdir -p /srv/gitlab/config /srv/gitlab/logs /srv/gitlab/data /srv/gitlab/backups
   ```

2. **Move Backup Files to the Container Environment**:
   - Move the backup file and configuration files to the appropriate directories:
     ```sh
     sudo mv /var/opt/gitlab/backups/your_backup.tar /srv/gitlab/backups/
     sudo mv /etc/gitlab/gitlab.rb /srv/gitlab/config/
     sudo mv /etc/gitlab/gitlab-secrets.json /srv/gitlab/config/
     ```

### Step 4: Run the GitLab CE Container with Podman

1. **Run the GitLab CE Container**:
   ```sh
   podman run --detach \
     --hostname your.gitlab.domain \
     --publish 80:80 --publish 443:443 --publish 22:22 \
     --name gitlab \
     --restart=always \
     --volume /srv/gitlab/config:/etc/gitlab \
     --volume /srv/gitlab/logs:/var/log/gitlab \
     --volume /srv/gitlab/data:/var/opt/gitlab \
     --volume /srv/gitlab/backups:/var/opt/gitlab/backups \
     --env GITLAB_OMNIBUS_CONFIG="external_url 'http://your.gitlab.domain'" \
     gitlab/gitlab-ce:latest
   ```

### Step 5: Restore Backup Data

1. **Access the GitLab Container**:
   ```sh
   podman exec -it gitlab /bin/bash
   ```

2. **Restore the Backup**:
   - Inside the container, run the restore command to restore the backup:
     ```sh
     gitlab-rake gitlab:backup:restore BACKUP=your_backup
     ```

3. **Reconfigure GitLab**:
   - Reconfigure GitLab to apply the restored settings:
     ```sh
     gitlab-ctl reconfigure
     ```

4. **Restart GitLab Services**:
   ```sh
   gitlab-ctl restart
   ```

### Step 6: Verify the Migration

1. **Access GitLab**:
   - Open your web browser and navigate to `http://your.gitlab.domain`.
   - Verify that your data and configurations have been restored correctly.

2. **Check Logs and Services**:
   - Check GitLab logs and services to ensure everything is running smoothly:
     ```sh
     gitlab-ctl status
     gitlab-ctl tail
     ```
3. Generate Systemd service
