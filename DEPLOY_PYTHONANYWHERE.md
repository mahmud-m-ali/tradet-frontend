# Deploy HalalEt to PythonAnywhere (Free Tier)

## Step 1: Create Account
1. Go to https://www.pythonanywhere.com/registration/register/beginner/
2. Sign up for a **free Beginner** account (no credit card needed)
3. Your site will be: `<username>.pythonanywhere.com`

## Step 2: Clone the Repo
1. Go to **Consoles** tab → Start a **Bash** console
2. Run:
```bash
git clone https://github.com/mahmud-m-ali/HalalEt.git ~/HalalEt
```

## Step 3: Set Up Python Environment
```bash
cd ~/HalalEt/backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Step 4: Initialize the Database
```bash
cd ~/HalalEt/backend
source venv/bin/activate
python database.py
```

## Step 5: Build & Upload Flutter Web (from your Mac)
On your local machine, the web build is already at:
`/Users/mahmud/Desktop/HalalEt/halalet_app/build/web/`

Upload it to PythonAnywhere:
1. Go to **Files** tab on PythonAnywhere
2. Navigate to `/home/<username>/HalalEt/halalet_app/build/`
3. Create `web/` directory if it doesn't exist
4. Upload all files from your local `build/web/` directory

**OR** use the Bash console to build directly (slower but simpler):
```bash
# This requires Flutter to be installed on PythonAnywhere (not available by default)
# So uploading from local is recommended
```

**Easiest method** — zip and upload:
```bash
# On your Mac, run:
cd /Users/mahmud/Desktop/HalalEt/halalet_app/build
zip -r ~/Desktop/halalet_web.zip web/

# Then upload halalet_web.zip via PythonAnywhere Files tab to ~/HalalEt/halalet_app/build/
# Then in PythonAnywhere Bash console:
cd ~/HalalEt/halalet_app/build
unzip halalet_web.zip
```

## Step 6: Create Web App
1. Go to **Web** tab
2. Click **"Add a new web app"**
3. Click **Next** (accept the free domain)
4. Choose **"Manual configuration"** (NOT "Flask")
5. Select **Python 3.13** (or latest)

## Step 7: Configure WSGI
1. In the Web tab, click the link to your **WSGI configuration file**
   (e.g., `/var/www/<username>_pythonanywhere_com_wsgi.py`)
2. **Delete all contents** and replace with:

```python
import sys
import os

project_home = '/home/<username>/HalalEt/backend'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

os.environ['DATABASE_PATH'] = '/home/<username>/HalalEt/backend/halalet.db'
os.environ['SECRET_KEY'] = 'pick-a-strong-random-secret-key-here'
os.environ['JWT_SECRET_KEY'] = 'pick-another-strong-random-secret-here'

from app import create_app
application = create_app()
```

**Replace `<username>` with your actual PythonAnywhere username!**

## Step 8: Set Virtualenv Path
In the Web tab, under **Virtualenv**, enter:
```
/home/<username>/HalalEt/backend/venv
```

## Step 9: Configure Static Files
In the Web tab, under **Static files**, add:

| URL | Directory |
|-----|-----------|
| `/static` | `/home/<username>/HalalEt/halalet_app/build/web` |

## Step 10: Reload
Click the green **"Reload"** button in the Web tab.

## Step 11: Test
- API: `https://<username>.pythonanywhere.com/api/health`
- Web App: `https://<username>.pythonanywhere.com/`

## Maintenance
- **Monthly renewal**: Log in every ~3 weeks and click "Run until 3 months from today" on the Web tab
- **Update code**: In Bash console, `cd ~/HalalEt && git pull`
- **Update web build**: Re-upload the `build/web/` directory after rebuilding locally

## Update Flutter App Default URL
After deployment, update your Flutter app to use the PythonAnywhere URL:
In `halalet_app/lib/services/api_service.dart`, change:
```dart
static const String _defaultTunnelUrl = 'https://<username>.pythonanywhere.com/api';
```
Then rebuild mobile apps.
