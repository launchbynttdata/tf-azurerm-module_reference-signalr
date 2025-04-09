package testimpl

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	armMetric "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/monitor/armmonitor"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/signalr/armsignalr"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"gotest.tools/v3/assert"
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

	signalrClient, err := armsignalr.NewClient(subscriptionId, credential, &options)
	if err != nil {
		t.Fatalf("failed to create SignalR client: %v", err)
	}

	armMetricAlertsClient, err := armMetric.NewMetricAlertsClient(subscriptionId, credential, &options)
	if err != nil {
		t.Fatalf("Error getting Metric Alerts client: %v", err)
	}

	t.Run("doesSignalRExist", func(t *testing.T) {
		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
		signalrName := terraform.Output(t, ctx.TerratestTerraformOptions(), "signalr_name")

		res, err := signalrClient.Get(context.Background(), resourceGroupName, signalrName, nil)
		if err != nil {
			t.Fatalf("failed to finish the request: %v", err)
		}

		assert.Equal(t, *res.Name, signalrName)
	})

	t.Run("doesMetricAlertsExist", func(t *testing.T) {
		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
		metricAlertsMap := terraform.OutputMapOfObjects(t, ctx.TerratestTerraformOptions(), "metric_alerts")
		var metricAlertsName string
		for _, v := range metricAlertsMap {
			metricAlertsName = v.(map[string]string)["name"]
			break // Access the first metric alert and break
		}

		metricAlerts, err := armMetricAlertsClient.Get(context.Background(), resourceGroupName, metricAlertsName, nil)
		if err != nil {
			t.Fatalf("Error getting MetricAlerts: %v", err)
		}

		assert.Equal(t, metricAlertsName, *metricAlerts.Name)
	})
}
