package test

import (
	"time"
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

var aws_region string  = "eu-west-1"

func TestTerraformSSMManagedInstance(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../dev/",
		TerraformBinary: "terraform",
		VarFiles: []string{"../dev/tests/vars.tfvars"},
		EnvVars: map[string]string{"TF_LOG":"ERROR"},
	})
	// instead of Terraform applying for each test, the output can just be consulted to get the output values for any
	// subsequent tests that need to be run

	// terraform.Apply(t, terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	aws_asg_name := terraform.Output(t, terraformOptions, "wordpress_asg_name")
	instance_ids := aws.GetInstanceIdsForAsg(t, aws_asg_name, aws_region)
	fmt.Sprintf("Autoscaling Group Name:\t%s", aws_asg_name)
	fmt.Sprintf("InstanceIds:\t%s", instance_ids)
	// placeholder until GetInstanceIdsFor ASG but is fixed 
	instance := "i-08938879e85be6de5"
	
	wait_period, _  := time.ParseDuration("1m30s")
	aws.WaitForSsmInstance(t, aws_region, instance, wait_period)
}