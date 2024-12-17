package testimpl

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/signalr/armsignalr"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"gotest.tools/v3/assert"
	// "github.com/stretchr/testify/assert"
)

func TestSignalRExists(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")

	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	options := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	clientFactory, err := armsignalr.NewClientFactory(subscriptionId, credential, &options)
	if err != nil {
		t.Fatalf("failed to create SignalR client: %v", err)
	}

	t.Run("doesSignalRExist", func(t *testing.T) {
		// resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
		signalr_name := terraform.Output(t, ctx.TerratestTerraformOptions(), "signalr_name")

		signalR, err := clientFactory.NewClient().CheckNameAvailability(context.Background(), "eastus", armsignalr.NameAvailabilityParameters{
			Name: to.Ptr(signalr_name),
			Type: to.Ptr("Microsoft.SignalRService/SignalR"),
		}, nil)
		if err != nil {
			t.Fatalf("failed to finish the request: %v", err)
		}

		assert.Assert(t, *signalR.NameAvailable)
	})

}
