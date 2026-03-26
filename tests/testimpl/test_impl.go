package testimpl

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/monitor/armmonitor"
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

	clientFactory, err := armsignalr.NewClientFactory(subscriptionId, credential, &options)
	if err != nil {
		t.Fatalf("failed to create SignalR client: %v", err)
	}

	t.Run("doesSignalRExist", func(t *testing.T) {
		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
		signalrName := terraform.Output(t, ctx.TerratestTerraformOptions(), "signalr_name")

		res, err := clientFactory.NewClient().Get(context.Background(), resourceGroupName, signalrName, nil)
		if err != nil {
			t.Fatalf("failed to finish the request: %v", err)
		}

		assert.Equal(t, *res.Name, signalrName)
	})

	t.Run("doesAutoscaleSettingExist", func(t *testing.T) {
		autoscaleName := terraform.Output(t, ctx.TerratestTerraformOptions(), "autoscale_setting_name")
		if autoscaleName == "" {
			t.Skip("autoscale_setting_name output is empty — autoscale setting not enabled")
		}

		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")

		autoscaleClient, err := armmonitor.NewAutoscaleSettingsClient(subscriptionId, credential, nil)
		if err != nil {
			t.Fatalf("failed to create AutoscaleSettings client: %v", err)
		}

		setting, err := autoscaleClient.Get(context.Background(), resourceGroupName, autoscaleName, nil)
		if err != nil {
			t.Fatalf("failed to get autoscale setting: %v", err)
		}

		assert.Equal(t, *setting.Name, autoscaleName)
		assert.Equal(t, *setting.Properties.Enabled, true)
		assert.Equal(t, len(setting.Properties.Profiles), 1)
		assert.Equal(t, *setting.Properties.Profiles[0].Name, "defaultProfile")
	})

	t.Run("doesActionGroupExist", func(t *testing.T) {
		actionGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "action_group_name")
		if actionGroupName == "" {
			t.Skip("action_group_name output is empty — action group not enabled")
		}

		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")

		actionGroupClient, err := armmonitor.NewActionGroupsClient(subscriptionId, credential, nil)
		if err != nil {
			t.Fatalf("failed to create ActionGroups client: %v", err)
		}

		ag, err := actionGroupClient.Get(context.Background(), resourceGroupName, actionGroupName, nil)
		if err != nil {
			t.Fatalf("failed to get action group: %v", err)
		}

		assert.Equal(t, *ag.Name, actionGroupName)
	})

	t.Run("doesMetricAlertExist", func(t *testing.T) {
		alertIDs := terraform.OutputMap(t, ctx.TerratestTerraformOptions(), "metric_alert_ids")
		if len(alertIDs) == 0 {
			t.Skip("metric_alert_ids output is empty — no metric alerts configured")
		}

		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")

		metricAlertClient, err := armmonitor.NewMetricAlertsClient(subscriptionId, credential, nil)
		if err != nil {
			t.Fatalf("failed to create MetricAlerts client: %v", err)
		}

		for alertName := range alertIDs {
			alert, err := metricAlertClient.Get(context.Background(), resourceGroupName, alertName, nil)
			if err != nil {
				t.Fatalf("failed to get metric alert %q: %v", alertName, err)
			}
			assert.Equal(t, *alert.Name, alertName)
			assert.Equal(t, *alert.Properties.Enabled, true)
		}
	})
}
