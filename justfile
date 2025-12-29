#!/usr/bin/env -S just --justfile

# List available recipes
default:
    @just --list

# Build the project in release mode
build:
    cargo build --release

# Build the project in development mode
build-dev:
    cargo build

# Run the project from source
run *ARGS:
    cargo run {{ ARGS }}

# Install the binary globally
install:
    cargo install --path .

# Uninstall the globally installed binary
uninstall:
    cargo uninstall betterfetch

# Reinstall the binary
reinstall: uninstall install

# Lint with Clippy
lint:
    cargo clippy --all-targets --all-features -- -D warnings

# Format the code
fmt:
    cargo fmt --all

# Check formatting without modifying files
fmt-check:
    cargo fmt --all -- --check

# Run tests
test:
    cargo test

# Run tests with output
test-verbose:
    cargo test -- --nocapture

# Clean build artifacts
clean:
    cargo clean

# Clean and rebuild in release mode
rebuild: clean build

# Generate and open documentation
doc:
    cargo doc --open

# Generate documentation without opening
doc-no-open:
    cargo doc

# Check the project for errors without building
check:
    cargo check

# Check all targets and features
check-all:
    cargo check --all-targets --all-features

# Run all quality checks (fmt, clippy, test)
ci: fmt-check lint test

# Show a short git status
stat-short:
    @git status -s

# Run cargo with all warnings as errors
strict:
    RUSTFLAGS="-D warnings" cargo build --all-targets --all-features

# Watch for changes and run tests
watch-test:
    cargo watch -x test

# Watch for changes and run the project
watch-run:
    cargo watch -x run

# Show outdated dependencies
outdated:
    cargo outdated

# Update dependencies
update:
    cargo update

# Show the dependency tree
tree:
    cargo tree

# Benchmark (if benchmarks exist)
bench:
    cargo bench

# Generate code coverage report (requires cargo-tarpaulin)
coverage:
    cargo tarpaulin --out Html

# Profile release build
profile:
    cargo build --release
    @echo "Binary built at: target/release/betterfetch"
