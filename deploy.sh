#!/bin/bash

# OpenChatApp Deployment Script
# This script provides easy access to common Fastlane commands

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if required tools are installed
check_requirements() {
    print_status "Checking requirements..."

    if ! command -v ruby &> /dev/null; then
        print_error "Ruby is not installed. Please install Ruby 2.6 or later."
        exit 1
    fi

    if ! command -v bundle &> /dev/null; then
        print_error "Bundler is not installed. Please install it with: gem install bundler"
        exit 1
    fi

    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode command line tools are not installed. Please install Xcode."
        exit 1
    fi

    print_success "All requirements are met!"
}

# Function to install dependencies
install_dependencies() {
    print_status "Installing Ruby dependencies..."
    bundle install
    print_success "Dependencies installed successfully!"
}

# Function to setup the project
setup_project() {
    print_status "Setting up the project..."
    bundle exec fastlane setup
    print_success "Project setup completed!"
}

# Function to build the app
build_app() {
    local config=${1:-"Debug"}
    print_status "Building app for $config configuration..."

    if [ "$config" = "Release" ]; then
        bundle exec fastlane build_release
    else
        bundle exec fastlane build
    fi

    print_success "Build completed successfully!"
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    bundle exec fastlane test
    print_success "Tests completed successfully!"
}

# Function to deploy to TestFlight
deploy_beta() {
    print_status "Deploying to TestFlight..."
    bundle exec fastlane beta
    print_success "Beta deployment completed!"
}

# Function to submit to App Store
submit_release() {
    print_status "Submitting to App Store..."
    bundle exec fastlane release
    print_success "App Store submission completed!"
}

# Function to clean build artifacts
clean_build() {
    print_status "Cleaning build artifacts..."
    bundle exec fastlane clean
    print_success "Clean completed!"
}

# Function to show help
show_help() {
    echo "OpenChatApp Deployment Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  setup           Setup the project and install dependencies"
    echo "  build           Build the app for development"
    echo "  build-release   Build the app for release"
    echo "  test            Run tests"
    echo "  beta            Deploy to TestFlight"
    echo "  release         Submit to App Store"
    echo "  clean           Clean build artifacts"
    echo "  full-release    Complete release process (test + beta + release)"
    echo "  help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 setup"
    echo "  $0 build"
    echo "  $0 beta"
    echo "  $0 release"
    echo ""
}

# Main script logic
main() {
    local command=${1:-"help"}

    case $command in
        "setup")
            check_requirements
            install_dependencies
            setup_project
            ;;
        "build")
            check_requirements
            build_app "Debug"
            ;;
        "build-release")
            check_requirements
            build_app "Release"
            ;;
        "test")
            check_requirements
            run_tests
            ;;
        "beta")
            check_requirements
            deploy_beta
            ;;
        "release")
            check_requirements
            submit_release
            ;;
        "clean")
            check_requirements
            clean_build
            ;;
        "full-release")
            check_requirements
            print_status "Starting full release process..."
            run_tests
            deploy_beta
            echo ""
            read -p "Ready to submit to App Store? (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                submit_release
            else
                print_warning "App Store submission skipped."
            fi
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Check if script is run from the correct directory
if [ ! -f "Podfile" ] || [ ! -f "fastlane/Fastfile" ]; then
    print_error "This script must be run from the project root directory (where Podfile and fastlane/ are located)."
    exit 1
fi

# Run the main function with all arguments
main "$@"