# OpenChatApp Deployment Script for Windows
# This script provides easy access to common Fastlane commands

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Function to check if required tools are installed
function Test-Requirements {
    Write-Status "Checking requirements..."

    # Check if Ruby is installed
    try {
        $rubyVersion = ruby --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "Ruby not found"
        }
        Write-Status "Ruby found: $rubyVersion"
    }
    catch {
        Write-Error "Ruby is not installed. Please install Ruby 2.6 or later."
        exit 1
    }

    # Check if Bundler is installed
    try {
        $bundleVersion = bundle --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "Bundler not found"
        }
        Write-Status "Bundler found: $bundleVersion"
    }
    catch {
        Write-Error "Bundler is not installed. Please install it with: gem install bundler"
        exit 1
    }

    # Check if Xcode command line tools are available (on macOS)
    if ($IsMacOS) {
        try {
            $xcodeVersion = xcodebuild -version 2>$null
            if ($LASTEXITCODE -ne 0) {
                throw "Xcode command line tools not found"
            }
            Write-Status "Xcode found: $xcodeVersion"
        }
        catch {
            Write-Error "Xcode command line tools are not installed. Please install Xcode."
            exit 1
        }
    }

    Write-Success "All requirements are met!"
}

# Function to install dependencies
function Install-Dependencies {
    Write-Status "Installing Ruby dependencies..."
    bundle install
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Dependencies installed successfully!"
    } else {
        Write-Error "Failed to install dependencies"
        exit 1
    }
}

# Function to setup the project
function Setup-Project {
    Write-Status "Setting up the project..."
    bundle exec fastlane setup
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Project setup completed!"
    } else {
        Write-Error "Project setup failed"
        exit 1
    }
}

# Function to build the app
function Build-App {
    param([string]$Config = "Debug")
    Write-Status "Building app for $Config configuration..."

    if ($Config -eq "Release") {
        bundle exec fastlane build_release
    } else {
        bundle exec fastlane build
    }

    if ($LASTEXITCODE -eq 0) {
        Write-Success "Build completed successfully!"
    } else {
        Write-Error "Build failed"
        exit 1
    }
}

# Function to run tests
function Run-Tests {
    Write-Status "Running tests..."
    bundle exec fastlane test
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Tests completed successfully!"
    } else {
        Write-Error "Tests failed"
        exit 1
    }
}

# Function to deploy to TestFlight
function Deploy-Beta {
    Write-Status "Deploying to TestFlight..."
    bundle exec fastlane beta
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Beta deployment completed!"
    } else {
        Write-Error "Beta deployment failed"
        exit 1
    }
}

# Function to submit to App Store
function Submit-Release {
    Write-Status "Submitting to App Store..."
    bundle exec fastlane release
    if ($LASTEXITCODE -eq 0) {
        Write-Success "App Store submission completed!"
    } else {
        Write-Error "App Store submission failed"
        exit 1
    }
}

# Function to clean build artifacts
function Clean-Build {
    Write-Status "Cleaning build artifacts..."
    bundle exec fastlane clean
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Clean completed!"
    } else {
        Write-Error "Clean failed"
        exit 1
    }
}

# Function to show help
function Show-Help {
    Write-Host "OpenChatApp Deployment Script for Windows" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\deploy.ps1 [COMMAND]" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  setup           Setup the project and install dependencies"
    Write-Host "  build           Build the app for development"
    Write-Host "  build-release   Build the app for release"
    Write-Host "  test            Run tests"
    Write-Host "  beta            Deploy to TestFlight"
    Write-Host "  release         Submit to App Store"
    Write-Host "  clean           Clean build artifacts"
    Write-Host "  full-release    Complete release process (test + beta + release)"
    Write-Host "  help            Show this help message"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\deploy.ps1 setup"
    Write-Host "  .\deploy.ps1 build"
    Write-Host "  .\deploy.ps1 beta"
    Write-Host "  .\deploy.ps1 release"
    Write-Host ""
}

# Function to run full release process
function Start-FullRelease {
    Write-Status "Starting full release process..."
    Run-Tests
    Deploy-Beta

    Write-Host ""
    $response = Read-Host "Ready to submit to App Store? (y/n)"
    if ($response -eq "y" -or $response -eq "Y") {
        Submit-Release
    } else {
        Write-Warning "App Store submission skipped."
    }
}

# Check if script is run from the correct directory
if (-not (Test-Path "Podfile") -or -not (Test-Path "fastlane\Fastfile")) {
    Write-Error "This script must be run from the project root directory (where Podfile and fastlane\ are located)."
    exit 1
}

# Main script logic
switch ($Command.ToLower()) {
    "setup" {
        Test-Requirements
        Install-Dependencies
        Setup-Project
    }
    "build" {
        Test-Requirements
        Build-App "Debug"
    }
    "build-release" {
        Test-Requirements
        Build-App "Release"
    }
    "test" {
        Test-Requirements
        Run-Tests
    }
    "beta" {
        Test-Requirements
        Deploy-Beta
    }
    "release" {
        Test-Requirements
        Submit-Release
    }
    "clean" {
        Test-Requirements
        Clean-Build
    }
    "full-release" {
        Test-Requirements
        Start-FullRelease
    }
    "help" {
        Show-Help
    }
    default {
        Write-Error "Unknown command: $Command"
        Show-Help
        exit 1
    }
}