# Doable Deployment Plan - Kamal to Production

## Overview

This plan will guide you through deploying your Doable Rails 8 app to production using Kamal, the deployment tool that ships with Rails 8. No Heroku, Render, or Vercel needed—just Rails on a machine you control.

**Video Reference**: [TypeCraft Tutorial](https://www.youtube.com/watch/_lRlOGS8Bgo)

---

## How Kamal Works (Simplified)

```
┌─────────────────┐
│ Your Computer   │
│   ┌─────────┐   │
│   │ Kamal   │   │
│   └────┬────┘   │
└────────┼────────┘
         │
    ┌────┴────────────────────────────┐
    │                                  │
    ▼                                  ▼
┌─────────┐                    ┌──────────────┐
│ GitHub  │                    │  DockerHub   │
│ (Code)  │◄───Build Image────►│ (Registry)   │
└─────────┘                    └──────┬───────┘
                                      │
                                      │ SSH + Pull
                                      │
                                      ▼
                               ┌─────────────┐
                               │   Server    │
                               │ DigitalOcean│
                               │  (or VPS)   │
                               └─────────────┘
```

**Workflow**:
1. Kamal grabs latest code from GitHub
2. Builds Docker image of your Rails app
3. Pushes image to DockerHub (container registry)
4. SSHs into your server (VPS)
5. Pulls image from DockerHub
6. Runs the image as a container

---

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] **Docker installed locally** (Docker Desktop for Mac/Windows, or Docker Engine for Linux)
- [ ] **DockerHub account** (free for public images)
- [ ] **VPS/Server** with SSH access (DigitalOcean droplet, AWS EC2, Linode, etc.)
- [ ] **Git repository** pushed to GitHub
- [ ] **Domain name** (optional but recommended for SSL)

---

## Phase 1: DockerHub Setup (5-10 minutes)

### Step 1.1: Create DockerHub Account

1. Go to [https://hub.docker.com/](https://hub.docker.com/)
2. Sign up for a free account
3. Note your **username** (you'll need this in config)

### Step 1.2: Create Access Token

1. Log in to DockerHub
2. Click on your profile → **Account Settings**
3. Navigate to **Security** → **Personal Access Tokens**
4. Click **Generate New Token**
5. Token settings:
   - **Description**: `doable-app-token` (or whatever you prefer)
   - **Access permissions**: **Read, Write, Delete** (full access)
6. Click **Generate**
7. **IMPORTANT**: Copy the token immediately—you won't see it again
8. Save token securely (you'll use it as `KAMAL_REGISTRY_PASSWORD`)

**Example token format**: `dckr_pat_1a2b3c4d5e6f7g8h9i0j`

---

## Phase 2: Server Setup (10-15 minutes)

### Step 2.1: Create VPS Instance

**Option A: DigitalOcean Droplet (Recommended)**

1. Go to [https://www.digitalocean.com/](https://www.digitalocean.com/)
2. Create new Droplet:
   - **Image**: Ubuntu 22.04 LTS (or latest)
   - **Plan**: Basic ($6-12/month should suffice for small apps)
   - **CPU Options**: Regular (Shared CPU)
   - **Region**: Choose closest to your users (e.g., NYC, SFO, AMS)
   - **Authentication**: SSH keys (recommended) or root password
   - **Hostname**: `doable-production` (or similar)
3. Click **Create Droplet**
4. Note the **IP address** (e.g., `165.227.123.45`)

**Option B: Other VPS Providers**
- AWS EC2 (Ubuntu AMI)
- Linode
- Vultr
- Hetzner
- Your own server

**Requirements**:
- Must be able to SSH into the machine
- Ubuntu/Debian preferred (Kamal handles Docker installation)

### Step 2.2: Set Up SSH Access

Test SSH connection from your local machine:

```bash
ssh root@YOUR_SERVER_IP
```

If successful, you should see the Ubuntu welcome message. Type `exit` to disconnect.

**Troubleshooting**:
- If using password auth, you'll be prompted for password
- If using SSH keys, ensure your key is added to the server
- For DigitalOcean, keys can be added during droplet creation

### Step 2.3: Create Volume for Database (Optional but Recommended)

**Why**: SQLite is file-based. If you change servers or reset, you don't want to lose your database.

**DigitalOcean**:
1. Go to **Volumes** in sidebar
2. Click **Create Volume**
3. Settings:
   - **Volume name**: `doable-storage` (or similar)
   - **Size**: 10 GB (adjust as needed)
   - **Region**: Same as your droplet
4. Attach to your droplet
5. Note the volume name (e.g., `volume-nyc1-06`)

**Other providers**: Look for "Block Storage" or "Volumes" feature

---

## Phase 3: Domain Setup (Optional - 15-20 minutes)

### Step 3.1: Create Subdomain

If you have a domain (e.g., `yourdomain.com`), create a subdomain for your app:

1. Go to your domain registrar (Namecheap, GoDaddy, CloudFlare, etc.)
2. Navigate to DNS settings
3. Add **A Record**:
   - **Name/Host**: `doable` (creates `doable.yourdomain.com`)
   - **Type**: `A`
   - **Value/Points to**: Your server IP (e.g., `165.227.123.45`)
   - **TTL**: 300 (or default)
4. Save changes

**DNS Propagation**: May take 5 minutes to 48 hours (usually ~15 minutes)

**Test**: Ping your subdomain to verify:
```bash
ping doable.yourdomain.com
```

### Step 3.2: SSL Certificate (Automatic)

**Good news**: Kamal automatically sets up SSL via Let's Encrypt when you specify a `host` in config. No manual setup needed!

---

## Phase 4: Configure Kamal (20-30 minutes)

### Step 4.1: Review Current Configuration

Your Doable app already has Kamal config files (ships with Rails 8):
- `config/deploy.yml` - Main deployment configuration
- `.kamal/secrets` - Environment variables and secrets

### Step 4.2: Edit `config/deploy.yml`

Open `config/deploy.yml` and update the following sections:

#### **Service Name** (Line ~3)
```yaml
service: doable
```
✅ Leave as is (already correct)

#### **Image Name** (Line ~5)
```yaml
image: YOUR_DOCKERHUB_USERNAME/doable
```
**Action**: Replace `YOUR_DOCKERHUB_USERNAME` with your DockerHub username

**Example**:
```yaml
image: estebanvargas/doable
```

#### **Server IP Address** (Line ~10)
```yaml
servers:
  web:
    - YOUR_SERVER_IP
```
**Action**: Replace `YOUR_SERVER_IP` with your VPS IP address

**Example**:
```yaml
servers:
  web:
    - 165.227.123.45
```

#### **Proxy/Host Configuration** (Line ~35-40)
```yaml
proxy:
  ssl: true
  host: YOUR_DOMAIN_OR_SUBDOMAIN
```

**Option A**: With domain (enables SSL)
```yaml
proxy:
  ssl: true
  host: doable.yourdomain.com
```

**Option B**: Without domain (HTTP only)
```yaml
proxy:
  ssl: false
  # host: 165.227.123.45  # Comment out or remove
```

#### **Registry Configuration** (Line ~50-55)
```yaml
registry:
  server: https://index.docker.io/v1/
  username: YOUR_DOCKERHUB_USERNAME
  password:
    - KAMAL_REGISTRY_PASSWORD
```

**Action**: Replace `YOUR_DOCKERHUB_USERNAME` with your DockerHub username

**Example**:
```yaml
registry:
  server: https://index.docker.io/v1/
  username: estebanvargas
  password:
    - KAMAL_REGISTRY_PASSWORD
```

#### **Volume Configuration** (Line ~70-75)

**If you created a volume** (Step 2.3):
```yaml
volumes:
  - "YOUR_VOLUME_NAME:/rails/storage"
```

**Example** (DigitalOcean):
```yaml
volumes:
  - "volume-nyc1-06:/rails/storage"
```

**If no volume** (not recommended for production):
```yaml
volumes:
  - "/var/lib/doable-storage:/rails/storage"
```

### Step 4.3: Review `.kamal/secrets`

Open `.kamal/secrets` and confirm it has:

```ruby
# Lines 13-14
KAMAL_REGISTRY_PASSWORD="$(fetch_env KAMAL_REGISTRY_PASSWORD)"
```

This tells Kamal to read `KAMAL_REGISTRY_PASSWORD` from your environment variables.

**Note**: For this tutorial, we'll set this in the terminal command. For production, use a secrets manager (1Password CLI, dotenv, etc.)

---

## Phase 5: Pre-Deployment Checks (5-10 minutes)

### Step 5.1: Ensure Docker is Running

**Mac/Windows**:
- Open Docker Desktop
- Ensure the whale icon in menu bar shows "Docker Desktop is running"

**Linux**:
```bash
sudo systemctl start docker
sudo systemctl status docker
```

### Step 5.2: Verify Git Repository

Kamal builds from your Git repository. Ensure all changes are committed and pushed:

```bash
git status
git add .
git commit -m "Prepare for Kamal deployment"
git push origin main
```

### Step 5.3: Test Local Docker Build (Optional)

Verify your Dockerfile works locally:

```bash
docker build -t doable-test .
```

If successful, you'll see "Successfully built" and "Successfully tagged doable-test"

---

## Phase 6: Deploy to Production (10-15 minutes)

### Step 6.1: Set Registry Password Environment Variable

In your terminal (from project root), set the DockerHub token:

```bash
export KAMAL_REGISTRY_PASSWORD="your_dockerhub_token_here"
```

**Example**:
```bash
export KAMAL_REGISTRY_PASSWORD="dckr_pat_1a2b3c4d5e6f7g8h9i0j"
```

**Verify it's set**:
```bash
echo $KAMAL_REGISTRY_PASSWORD
```

### Step 6.2: Run Kamal Setup

This is the big moment! Run:

```bash
kamal setup
```

**What happens**:
1. Builds Docker image from your code (~1-3 minutes)
2. Pushes image to DockerHub (~1-2 minutes)
3. SSHs into your server
4. Installs Docker on server (if not already installed)
5. Pulls image from DockerHub
6. Runs database migrations
7. Starts application container
8. Configures Thruster proxy
9. Sets up SSL (if domain configured)

**Expected output**:
```
INFO [abc123] Building Docker image...
INFO [abc123] Finished building in 86 seconds
INFO [abc123] Pushing to estebanvargas/doable:abc123
INFO [abc123] Pushed to registry
INFO [165.227.123.45] Installing Docker...
INFO [165.227.123.45] Pulling image...
INFO [165.227.123.45] Starting application...
INFO [165.227.123.45] Finished deploying
```

### Step 6.3: Verify Deployment

**With domain**:
```bash
curl https://doable.yourdomain.com
```

**Without domain**:
```bash
curl http://YOUR_SERVER_IP
```

**Or visit in browser**:
- `https://doable.yourdomain.com`
- or `http://YOUR_SERVER_IP`

You should see your Doable app!

---

## Phase 7: Post-Deployment Management

### Common Kamal Commands

#### View Live Logs
```bash
KAMAL_REGISTRY_PASSWORD="your_token" kamal logs --follow
```

Or shorter:
```bash
export KAMAL_REGISTRY_PASSWORD="your_token"
kamal logs -f
```

#### Rails Console in Production
```bash
kamal console
```

Inside console:
```ruby
Todo.all
Project.count
```

Type `exit` to leave console.

#### Run Migrations
```bash
kamal app exec 'bin/rails db:migrate'
```

#### Restart Application
```bash
kamal app restart
```

#### Redeploy (after code changes)
```bash
git add .
git commit -m "New feature"
git push origin main
kamal deploy
```

`kamal deploy` is faster than `kamal setup` (doesn't reinstall Docker, etc.)

#### Rollback to Previous Version
```bash
kamal rollback
```

#### Check Application Status
```bash
kamal app details
```

#### SSH into Server
```bash
kamal app exec --interactive /bin/bash
```

Or directly:
```bash
ssh root@YOUR_SERVER_IP
```

---

## Phase 8: Security & Best Practices

### 8.1: Secure Your Registry Token

**Current method** (tutorial demo only):
```bash
export KAMAL_REGISTRY_PASSWORD="token"
```

**Production-ready methods**:

#### Option A: 1Password CLI
```bash
# Install 1Password CLI
brew install --cask 1password-cli

# Store token in 1Password
op item create --category=login --title="Doable DockerHub Token" \
  username="estebanvargas" password="your_token_here"

# Update .kamal/secrets
KAMAL_REGISTRY_PASSWORD="$(op read "op://Private/Doable DockerHub Token/password")"
```

#### Option B: dotenv (Ruby gem)
```bash
# Add to Gemfile
gem 'dotenv-rails', groups: [:development, :test]

# Create .env file (add to .gitignore!)
echo "KAMAL_REGISTRY_PASSWORD=your_token_here" > .env
echo ".env" >> .gitignore

# Update .kamal/secrets to read from ENV
KAMAL_REGISTRY_PASSWORD="$(fetch_env KAMAL_REGISTRY_PASSWORD)"
```

#### Option C: System Keychain
```bash
# Mac only
security add-generic-password -s "kamal_registry" -a "$USER" -w "your_token_here"

# Update .kamal/secrets
KAMAL_REGISTRY_PASSWORD="$(security find-generic-password -s 'kamal_registry' -w)"
```

### 8.2: Configure Firewall

On your server:
```bash
ssh root@YOUR_SERVER_IP
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw enable
```

### 8.3: Set Up Database Backups

For SQLite on volume:
```bash
# Cron job on server
0 2 * * * sqlite3 /var/lib/doable-storage/production.sqlite3 ".backup /backups/doable-$(date +\%Y\%m\%d).sqlite3"
```

Consider migrating to PostgreSQL for production apps with high traffic.

### 8.4: Monitor Application

**Install error tracking**:
- [Sentry](https://sentry.io/) (free tier available)
- [Rollbar](https://rollbar.com/)
- [Honeybadger](https://www.honeybadger.io/)

**Add to Gemfile**:
```ruby
gem 'sentry-ruby'
gem 'sentry-rails'
```

---

## Troubleshooting

### Issue 1: "Docker not found" error

**Solution**: Ensure Docker Desktop is running (Mac/Windows) or Docker daemon is started (Linux)

### Issue 2: "Permission denied (publickey)" SSH error

**Solution**: Add your SSH key to the server
```bash
ssh-copy-id root@YOUR_SERVER_IP
```

### Issue 3: DNS not resolving

**Solution**: Wait for DNS propagation (up to 48 hours, usually 15 minutes). Test with:
```bash
nslookup doable.yourdomain.com
```

### Issue 4: "Image push failed" to DockerHub

**Solutions**:
- Verify `KAMAL_REGISTRY_PASSWORD` is set: `echo $KAMAL_REGISTRY_PASSWORD`
- Check DockerHub username matches in `config/deploy.yml`
- Ensure token has Read/Write/Delete permissions

### Issue 5: Application not starting

**Debug steps**:
```bash
# Check logs
kamal app logs

# SSH into server and inspect
ssh root@YOUR_SERVER_IP
docker ps -a
docker logs doable-web-1
```

### Issue 6: SSL certificate issues

**Solution**: Ensure:
- Domain DNS is properly configured
- Port 80 and 443 are open on server
- `host:` in `config/deploy.yml` matches your domain exactly

---

## Cost Estimation

### Monthly Costs

| Service | Plan | Cost |
|---------|------|------|
| **DockerHub** | Free (public images) | $0 |
| **DigitalOcean Droplet** | Basic (2GB RAM, 1 vCPU) | $12 |
| **DigitalOcean Volume** | 10GB Block Storage | $1 |
| **Domain** | .com (optional) | ~$12/year ($1/mo) |
| **Total** |  | **~$14/month** |

**Compare to**:
- Heroku: $7/month (Eco dyno) + $5 (Postgres) = $12/month (limited resources)
- Render: $7/month (Starter) + $7 (PostgreSQL) = $14/month (limited resources)
- Vercel: Not ideal for Rails apps

**Advantages of VPS + Kamal**:
- Full control over server
- No platform lock-in
- Scalable (easily upgrade droplet size)
- Learn valuable DevOps skills

---

## Next Steps After Deployment

1. **Set up continuous deployment (CD)**
   - GitHub Actions to auto-deploy on push to `main`
   - Example workflow in `.github/workflows/deploy.yml`

2. **Add monitoring**
   - Uptime monitoring (UptimeRobot, Pingdom)
   - Application performance monitoring (Scout, New Relic)

3. **Configure custom domain root**
   - Point `yourdomain.com` (not just subdomain) to your app

4. **Scale horizontally**
   - Add more servers to `config/deploy.yml`
   - Kamal handles load balancing

5. **Migrate to PostgreSQL**
   - For production apps, consider PostgreSQL over SQLite
   - Managed databases: DigitalOcean, AWS RDS, Render

---

## Quick Reference Card

### Essential Commands

```bash
# Set token (required for most commands)
export KAMAL_REGISTRY_PASSWORD="your_token"

# Initial setup
kamal setup

# Deploy after changes
kamal deploy

# View logs
kamal logs -f

# Rails console
kamal console

# Rollback deployment
kamal rollback

# Check app status
kamal app details

# SSH into server
ssh root@YOUR_SERVER_IP
```

### File Locations

| File | Purpose |
|------|---------|
| `config/deploy.yml` | Main Kamal configuration |
| `.kamal/secrets` | Environment variables |
| `Dockerfile` | Docker image definition (auto-generated) |
| `Procfile.dev` | Local development processes |

---

## Resources

- **Kamal Documentation**: [kamal-deploy.org](https://kamal-deploy.org/)
- **TypeCraft Tutorial**: [YouTube Video](https://www.youtube.com/watch/_lRlOGS8Bgo)
- **Rails 8 Guide**: [guides.rubyonrails.org](https://guides.rubyonrails.org/)
- **DockerHub**: [hub.docker.com](https://hub.docker.com/)
- **DigitalOcean**: [digitalocean.com](https://www.digitalocean.com/)
- **Let's Encrypt**: [letsencrypt.org](https://letsencrypt.org/)

---

## Checklist Summary

### Pre-Deployment
- [ ] Docker installed locally and running
- [ ] DockerHub account created
- [ ] DockerHub access token generated
- [ ] VPS/server created with SSH access
- [ ] (Optional) Volume created for database
- [ ] (Optional) Domain/subdomain configured with A record

### Configuration
- [ ] `config/deploy.yml` updated:
  - [ ] `image:` set to `dockerhub_username/doable`
  - [ ] `servers: web:` set to server IP
  - [ ] `proxy: host:` set to domain (or commented out)
  - [ ] `registry: username:` set to DockerHub username
  - [ ] `volumes:` configured (if using)
- [ ] All code committed and pushed to GitHub
- [ ] `KAMAL_REGISTRY_PASSWORD` environment variable set

### Deployment
- [ ] Ran `kamal setup` successfully
- [ ] Application accessible at domain/IP
- [ ] SSL certificate active (if using domain)
- [ ] Logs viewable with `kamal logs`
- [ ] Rails console accessible with `kamal console`

### Post-Deployment
- [ ] Database backups configured
- [ ] Error tracking installed (Sentry, etc.)
- [ ] Monitoring set up (uptime checks)
- [ ] Secrets secured (moved from terminal to vault)
- [ ] Firewall configured on server
- [ ] DockerHub deployment token saved securely

---

**🎉 Congratulations!** Your Doable app is now live in production!

---

*Generated: 2025-10-28*
*Based on: [TypeCraft Doable Deployment Tutorial](https://www.youtube.com/watch/_lRlOGS8Bgo)*
