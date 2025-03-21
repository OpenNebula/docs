.. _monitor_alert_forecast:

================================================================================
Resource Forecast
================================================================================

Overview
--------------------------------------------------------------------------------

The OpenNebula Resource Forecast system provides short-term and long-term predictions for resource usage across hosts and virtual machines. By forecasting metric trends and performance related to CPU, memory, network, and disk usage, it enables administrators to proactively manage resources. This predictive capability helps optimize resource allocation, anticipate potential bottlenecks, and ensure the efficiency and stability of both infrastructure and virtual resources.

.. note:: 
   Resource forecasting works automatically once configured and requires no additional action from administrators to generate predictions.

Key Benefits
--------------------------------------------------------------------------------

* **Proactive resource management** - Identify potential resource constraints before they impact performance
* **Improved capacity planning** - Make informed decisions about infrastructure expansion
* **Enhanced workload scheduling** - Optimize VM placement based on predicted resource utilization
* **Better user experience** - Maintain consistent performance by avoiding resource contention

By integrating forecasting with the Distributed Resource Scheduler (DRS), cloud administrators gain access to a proactive tool for intelligent scheduling and resource optimization. This integration enables the system to anticipate potential issues in virtual machine workloads, facilitating dynamic adjustments to prevent performance bottlenecks, enhance workload balancing, and ensure optimal utilization of available resources. As a result, overall cluster efficiency, reliability, and performance can be significantly improved.

Types of Forecasts
================================================================================

OpenNebula provides two types of resource forecasts:

Long-term Forecast
--------------------------------------------------------------------------------

**Purpose**: Used for capacity planning, hardware provisioning, and resource allocation strategies.

Long-term forecast information is accessible through the CLI and Sunstone. Using Sunstone, when selecting a Virtual Machine or a Host, the "Monitoring" tab displays not only real-time resource usage data but also predicted long-term forecasts. These forecasts provide valuable insights into expected resource consumption trends, helping cloud administrators plan and allocate resources more effectively. 

[INSERT SUNSTONE IMAGE HERE FOR LONG-TERM FORECAST]

You can also use the CLI to access information about the long-term forecast.

[INSERT CLI INFORMATION HERE FOR LONG-TERM FORECAST]

By default, long-term forecast is performed for the next 30 days.

Short-term Forecast
--------------------------------------------------------------------------------

**Purpose**: Used for immediate operational decisions and dynamic resource adjustments.

Short-term forecasts are utilized by the Predictive DRS to optimize cluster load distribution based on CPU, memory, disk, and network predictions. To enable predictive capabilities for DRS, refer to the :ref:`Distributed Resource Scheduling section <drs>`. This ensures that scheduling decisions are informed by accurate and data-driven insights, enhancing resource efficiency.

Information about short-term forecasts can also be accessed using Sunstone. When selecting a Virtual Machine or a Host, the "Monitoring" tab displays not only real-time resource usage data but also predicted short-term forecasts.

[INSERT SUNSTONE IMAGE HERE FOR SHORT-TERM FORECAST]

You can also use the CLI to access information about the short-term forecast.

[INSERT CLI INFORMATION HERE FOR SHORT-TERM FORECAST]

By default, short-term forecast is performed for the next 5 minutes.

How Forecasting Works
================================================================================

Forecast Generation
--------------------------------------------------------------------------------

Forecasts are generated using the OpenNebula Built-in monitoring system (see :ref:`monitor_alert_monitor`). At defined intervals, a prediction probe is executed for both Hosts and Virtual Machines to analyze real-time resource usage metrics, including CPU, memory, disk, and network utilization.

Each host maintains a dedicated database (``/var/tmp/one_db/host.db``) that is continuously updated during monitoring cycles. This database stores historical metrics and is used for time-series analysis and prediction generation. The forecast computation process is distributed across all hosts within a cluster to enhance scalability and efficiency. For each VM running on a host, an individual database is created and stored in ``/var/tmp/one_db`` as ``<VM_ID>.db``.

.. note:: If a VM is migrated, the related DB will be created from scratch in the new host where the VM will be allocated. This will impact the forecast of that VM until enough data is monitored.

The forecast computation process:

1. Accesses the stored metrics from the database
2. Performs statistical analysis to identify trends, patterns, and seasonal variations
3. Computes predictive models that estimate future resource consumption
4. Sends generated predictions to the OpenNebula monitoring system
5. Makes predictions accessible via Sunstone, CLI, or for use by the Predictive DRS

Forecast Quality and Accuracy
--------------------------------------------------------------------------------

The accuracy of forecasts depends on several factors:

* **Historical data volume** - More data generally leads to better predictions
* **Data quality** - Consistent monitoring data without gaps improves accuracy
* **Workload predictability** - Regular patterns are easier to forecast than random spikes
* **Database retention period** - Longer retention captures more seasonal patterns

The retention period for both Host and Virtual Machine databases is configurable, enabling administrators to manage storage utilization efficiently while maintaining prediction accuracy. Database retention can impact the accuracy of predictions, particularly for long-term forecasts. The forecast module analyzes all historical data in the database to decompose time series data for different metrics into trends and seasonality. Depending on the data's seasonality and the duration of the long-term forecast, the database retention period should be appropriately configured, considering both the required storage size and prediction accuracy. 

.. warning:: The prediction module is sensitive to outliers. This means that the presence of outliers can have a negative effect on the predictions. Consider investigating unusual VM behavior if forecasts suddenly become less accurate.

For further details on configuring forecast retention or optimizing prediction accuracy, refer to the next section.

Configuration and Optimization
================================================================================

Configuration File
--------------------------------------------------------------------------------

The configuration file for the Resource Forecast can be found in ``/var/lib/one/remotes/kvm-probes.d/forecast.conf``.

The default configuration is the following:

.. code:: yaml

    # This section is related to the configuration for DB retention and forecast period
    # related to the hosts
    host:
        db_retention: 4 # Number of weeks
        forecast_period: 5 # Number of minutes
        forecast_far_period: 720 # Number of hours

    # This section is related to the configuration for DB retention and forecast 
    # related to the virtual machines
    virtualmachine:
        db_retention: 2 # Number of weeks
        forecast_period: 5 # Number of minutes
        forecast_far_period: 48 # Number of hours


The configuration file consists of two sections:

1. **Host section**: Controls forecast settings for physical hosts
2. **Virtual Machine section**: Controls forecast settings for VMs

Default Configuration Values
--------------------------------------------------------------------------------

**Host settings**:
* DB retention: 4 weeks
* Short-term forecast: 5 minutes
* Long-term forecast: 720 hours (30 days)

**Virtual Machine settings**:
* DB retention: 2 weeks
* Short-term forecast: 5 minutes
* Long-term forecast: 48 hours (2 days)

Storage Considerations
--------------------------------------------------------------------------------

The size of forecast databases depends on retention periods and monitoring frequency:

* **Host database**: ~2.5 MB for 4 weeks of data (6 metrics, 2-minute interval)
* **VM database**: ~6.5 MB for 2 weeks of data (8 metrics, 30-second interval)

You may need to adjust these values based on:
* Available storage capacity on hosts
* Number of VMs per host
* Accuracy requirements for forecasts
* Historical data needs for your specific workloads

After changing configuration values, monitoring will continue with the new settings without requiring a restart of OpenNebula services.

Practical Usage Tips
================================================================================

* **Start with defaults**: The default configuration works well for most environments
* **Increase retention gradually**: If you need more accurate long-term forecasts, increase retention periods incrementally
* **Monitor database sizes**: Check ``/var/tmp/one_db/`` periodically to ensure forecast DBs aren't consuming too much space
* **Consider workload patterns**: Adjust retention based on your workload cycles (daily, weekly, monthly)
* **Use short-term forecasts** for operational decisions and **long-term forecasts** for capacity planning

See Also
--------------------------------------------------------------------------------

* :ref:`OpenNebula Monitoring System <monitor_alert_monitor>`
* :ref:`Distributed Resource Scheduling <drs>`
* :ref:`VM Performance Monitoring <vm_monitoring>`