package test

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

func TestTerraformAWSALBApplicationURL(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../dev/",
		TerraformBinary: "terraform",
		VarFiles: []string{"../dev/tests/vars.tfvars"},
		EnvVars: map[string]string{"TF_LOG":"ERROR"},
	})
	
	// terraform.Apply(t, terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)
	wordpress_alb_dns := terraform.Output(t, terraformOptions, "wordpress_alb_dns")
	
	url := fmt.Sprintf("http://%s:80", wordpress_alb_dns)
	fmt.Printf("Application Load balancer URL:\t%s\n", url)
	http_helper.HttpGet(t, url, nil)
}