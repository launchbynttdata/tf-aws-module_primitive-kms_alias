package testimpl

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/kms"
	kmsTypes "github.com/aws/aws-sdk-go-v2/service/kms/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testTypes "github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestComposableComplete is the functional test entrypoint. It deploys the
// example, verifies the KMS alias and its target key, and tears the example
// down.
func TestComposableComplete(t *testing.T, ctx testTypes.TestContext) {
	verifyKMSAlias(t, ctx)
}

// TestComposableCompleteReadOnly is the readonly test entrypoint. It assumes
// the example is already deployed and performs the same read-only
// verification without triggering apply/destroy.
func TestComposableCompleteReadOnly(t *testing.T, ctx testTypes.TestContext) {
	verifyKMSAlias(t, ctx)
}

func verifyKMSAlias(t *testing.T, ctx testTypes.TestContext) {
	// Retrieve Terraform outputs
	kmsAliasArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "kms_alias_arn")
	targetKeyArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "target_key_arn")

	t.Run("OutputsPresent", func(t *testing.T) {
		assert.NotEmpty(t, kmsAliasArn, "kms_alias_arn output should not be empty")
		assert.NotEmpty(t, targetKeyArn, "target_key_arn output should not be empty")
	})

	aliasName := extractAliasName(kmsAliasArn)
	require.NotEmpty(t, aliasName, "Failed to derive alias name from kms_alias_arn output")

	keyID := extractKeyID(targetKeyArn)
	require.NotEmpty(t, keyID, "Failed to derive key ID from target_key_arn output")

	kmsClient := GetAWSKMSClient(t)

	aliasEntry := findAliasByName(t, kmsClient, aliasName)
	require.NotNil(t, aliasEntry, "KMS alias was not found via AWS API")

	keyMetadata := describeKey(t, kmsClient, targetKeyArn)
	require.NotNil(t, keyMetadata, "Target KMS key was not found via AWS API")

	t.Run("AliasAttributes", func(t *testing.T) {
		assert.Equal(t, kmsAliasArn, aws.ToString(aliasEntry.AliasArn), "Alias ARN should match Terraform output")
		assert.Equal(t, aliasName, aws.ToString(aliasEntry.AliasName), "Alias name should match parsed value")
		assert.True(t, aliasTargetsExpectedKey(aliasEntry, keyID, targetKeyArn), "Alias should target expected key identifier")
	})

	t.Run("KeyAttributes", func(t *testing.T) {
		assert.Equal(t, targetKeyArn, aws.ToString(keyMetadata.Arn), "Key ARN should match Terraform output")
		assert.Equal(t, keyID, aws.ToString(keyMetadata.KeyId), "Key ID from ARN should match DescribeKey response")
	})
}

func findAliasByName(t *testing.T, client *kms.Client, aliasName string) *kmsTypes.AliasListEntry {
	paginator := kms.NewListAliasesPaginator(client, &kms.ListAliasesInput{})

	for paginator.HasMorePages() {
		page, err := paginator.NextPage(context.TODO())
		require.NoError(t, err, "Failed to list KMS aliases")

		for _, alias := range page.Aliases {
			if aws.ToString(alias.AliasName) == aliasName {
				return &alias
			}
		}
	}

	return nil
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GetAWSKMSClient(t *testing.T) *kms.Client {
	return kms.NewFromConfig(GetAWSConfig(t))
}

func describeKey(t *testing.T, client *kms.Client, keyID string) *kmsTypes.KeyMetadata {
	output, err := client.DescribeKey(context.TODO(), &kms.DescribeKeyInput{KeyId: aws.String(keyID)})
	require.NoError(t, err, "Failed to describe KMS key")
	return output.KeyMetadata
}

func extractAliasName(aliasArn string) string {
	idx := strings.Index(aliasArn, "alias/")
	if idx == -1 {
		return ""
	}

	return aliasArn[idx:]
}

func extractKeyID(keyArn string) string {
	idx := strings.Index(keyArn, "key/")
	if idx == -1 {
		return ""
	}

	return keyArn[idx+len("key/"):]
}

func aliasTargetsExpectedKey(aliasEntry *kmsTypes.AliasListEntry, keyID string, keyArn string) bool {
	target := aws.ToString(aliasEntry.TargetKeyId)
	return target == keyID || target == keyArn
}
