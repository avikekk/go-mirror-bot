### Clone the repository

```bash
git clone https://github.com/avikekk/go-mirror-bot.git
cd go-mirror-bot
```

### Create a config.toml file

Create a `config.toml` file in the root directory with the following content:

```toml
BOT_TOKEN = "your_telegram_bot_token"
ARIA_DOWNLOAD_LOCATION = "/absolute/path/to/download/directory"
SUDO_USERS = [your_telegram_user_id]
AUTHORIZED_CHATS = [authorized_chat_ids]
GDRIVE_PARENT_DIR_ID = "your_google_drive_folder_id"
CLOUDFLARE_INDEX = "your_cloudflare_worker_url"
```

### Google Drive API Setup
Place your service account ex: 0.json in root dir and rename it to servie-account.json 

### Using the start script

```bash
chmod +x start.sh
./start.sh
```
## Bot Commands

- `/start` - Check if the bot is alive
- `/upload [URL]` - Download a file from URL and upload it to Google Drive
