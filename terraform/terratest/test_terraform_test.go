package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformDeployment(t *testing.T) {
	t.Parallel()

	// Define Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: "../live/dev",

		// Variables to pass to Terraform
		Vars: map[string]interface{}{
			"region": "eu-west-2",
		},
	}

	// Run `terraform init` and `terraform apply`
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	instancePublicIP := terraform.Output(t, terraformOptions, "ec2_public_ip")
	dbEndpoint := terraform.Output(t, terraformOptions, "rds_endpoint")

	// Ensure the outputs are not empty
	assert.NotEmpty(t, instancePublicIP, "EC2 Public IP should not be empty")
	assert.NotEmpty(t, dbEndpoint, "RDS Endpoint should not be empty")
}
