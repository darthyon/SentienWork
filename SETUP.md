# SentienWork Setup Guide

## Step 1: Enable Flutter Web Support

Run these commands in your terminal:

```bash
# Enable web support globally
flutter config --enable-web

# Get dependencies
flutter pub get

# Test web build
flutter build web --release
```

## Step 2: Initialize Git Repository

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: SentienWork Flutter app with web support"
```

## Step 3: Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Click "New repository" (green button)
3. Repository name: `SentienWork`
4. Description: `A career development and productivity application built with Flutter`
5. Make it **Public** (so you can use GitHub Pages for free)
6. **Don't** initialize with README (we already have one)
7. Click "Create repository"

## Step 4: Link Local Repository to GitHub

Replace `yourusername` with your actual GitHub username:

```bash
# Add GitHub remote
git remote add origin https://github.com/yourusername/SentienWork.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 5: Deploy to GitHub Pages (Optional)

1. Go to your repository on GitHub
2. Click "Settings" tab
3. Scroll to "Pages" in the left sidebar
4. Under "Source", select "GitHub Actions"
5. Create `.github/workflows/web.yml` (see below)

## GitHub Actions Workflow for Auto-Deploy

Create `.github/workflows/web.yml`:

```yaml
name: Deploy Flutter Web to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        
    - run: flutter pub get
    - run: flutter build web --release --base-href "/SentienWork/"
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

## Your App Will Be Available At:
`https://yourusername.github.io/SentienWork/`

## Local Development Commands

```bash
# Run on web browser
flutter run -d chrome

# Build for web
flutter build web

# Run on mobile simulator
flutter run
```
