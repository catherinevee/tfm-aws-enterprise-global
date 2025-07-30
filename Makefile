.PHONY: help init plan apply destroy validate fmt clean test

# Default target
help:
	@echo "Available commands:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan Terraform changes"
	@echo "  apply     - Apply Terraform changes"
	@echo "  destroy   - Destroy Terraform resources"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  fmt       - Format Terraform code"
	@echo "  clean     - Clean Terraform files"
	@echo "  test      - Run tests"

# Initialize Terraform
init:
	terraform init

# Plan Terraform changes
plan:
	terraform plan

# Apply Terraform changes
apply:
	terraform apply -auto-approve

# Destroy Terraform resources
destroy:
	terraform destroy -auto-approve

# Validate Terraform configuration
validate:
	terraform validate

# Format Terraform code
fmt:
	terraform fmt -recursive

# Clean Terraform files
clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup

# Run tests (if using Terratest)
test:
	@echo "Running tests..."
	@if [ -d "test" ]; then \
		cd test && go test -v -timeout 30m; \
	else \
		echo "No test directory found"; \
	fi

# Check for security issues with tfsec
security-check:
	@if command -v tfsec >/dev/null 2>&1; then \
		tfsec .; \
	else \
		echo "tfsec not installed. Install with: brew install tfsec"; \
	fi

# Check for linting issues with tflint
lint:
	@if command -v tflint >/dev/null 2>&1; then \
		tflint; \
	else \
		echo "tflint not installed. Install with: brew install tflint"; \
	fi

# Full validation pipeline
check: validate fmt security-check lint
	@echo "All checks completed successfully!"

# Example-specific commands
example-basic:
	cd examples/basic && terraform init && terraform plan

example-advanced:
	cd examples/advanced && terraform init && terraform plan

# Documentation
docs:
	@echo "Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown . > README.md; \
	else \
		echo "terraform-docs not installed. Install with: brew install terraform-docs"; \
	fi

# Cost estimation
cost:
	@echo "Estimating costs..."
	@if command -v infracost >/dev/null 2>&1; then \
		infracost breakdown --path .; \
	else \
		echo "infracost not installed. Install with: brew install infracost"; \
	fi 