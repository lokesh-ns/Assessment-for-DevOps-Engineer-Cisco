# WWW-Master — Findings Document

## Overview

A simple Flask application that serves and stores PNG images via two endpoints, authenticated
using a custom request header `X-Image-Secret`. The repository was reviewed and the following
fixes were applied.

---

## Fixes Applied

### Dockerfile
- Switched base image from `ubuntu` to `python:3.11-slim` — purpose-built, smaller, reproducible
- Removed `COPY README.md` — documentation does not belong in a container image
- Combined `apt-get` and `pip install` into a single `RUN` instruction — reduces image layers

### `APP_PORT` Correctness
- Original code used `os.environ['APP_PORT']` with no default — app crashed on startup if the variable was not set
- Fixed to `os.environ.get('APP_PORT', 80)` — falls back to port 80 if not specified

### `requirements.txt`
- Pinned `flask==3.1.1` — original had no version pin, causing non-reproducible builds

### `.dockerignore`
- Added `.dockerignore` to prevent sensitive files from being included in the build context
```
.git
.env
venv/
__pycache__
*.pyc
.DS_Store
```

---

## How to Build and Run

```bash
# Build
docker build -t www-master:latest .

# Run
docker run -d -p 5001:80 www-master:latest

# Test
curl http://localhost:5001/image/image100 \
  -H "X-Image-Secret: <secret>" \
  --output test.png && open test.png
```