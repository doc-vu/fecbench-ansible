Following package can be used for installing the FECBench infrastructure.

Requirements:
-----

A) Master Node: 
This node hosts following components:
1) InfluxDB
2) Chronograf/Grafana
3) RabbitMQ Server
4) FECBench Subscriber

B) Slave Nodes:
This node hosts following components:
1) CollectD Daemons


Installation Steps:

1) First install the ansible on the development machine.
One can use the install_ansible_ubuntu.sh for installing on ubuntu
Next, download all the ansible roles from the ansible galaxy.
Execute the install_requirements.sh script.

2) Update the fecbench_inv inventory files with the information 
of the IP addresses of the MASTER Node(Server) and the SLAVE Nodes(Client).
Also set the appropriate SSH key path and the remote user name.

```
[client]
x.x.x.x ansible_ssh_private_key_file="/home/vagrant/keys/chameli/chameleon.pem" ansible_python_interpreter=/usr/bin/python3 ansible_user=ubuntu

[server]
y.y.y.y ansible_ssh_private_key_file="/home/vagrant/keys/chameli/chameleon.pem" ansible_python_interpreter=/usr/bin/python3 ansible_user=ubuntu

```


3) Update the following variables in the following files:

 - File: server-deploy.yml fecbench_master_ip --> to the IP address of the Master Node
 - File: client-deploy.yml indices_manager_ip --> IP address of the Master Node

4) We also want to comment out the lines if the SLAVES have no GPU modules. The file to update is client-deploy.yml.
    ```
    #- {  role: apt-common,
    #     become: yes,
    #     ignore_error: yes
    #     }
    ```     
4) Now we are ready to install the packages.

```
 ansible-playbook playbooks/server-deploy.yml -i fecbench_inv --limit server -vvv
 
 ansible-playbook playbooks/client-deploy.yml -i fecbench_inv --limit client -vvv

```

To ensure everything is working.

For the Master Node:

1) Check the Chronograph is installed: http://master-node-ip:8888/
2) Make sure that the FECBench Subscriber Program is running on the Master Node
   Under /root/pycollectdsubscriber directory. Run 
   ```
   sh run_collector.sh
   ```

On the Client Machine:

1) Ensure the collectd daemon is running.

```
sudo service collectd status
```



Schema for the InfluxDB Database:
------

```
> show tag keys
name: container_metrics
tagKey
------
host
instance

name: host_gpu_metrics
tagKey
------
host
instance

name: host_metrics
tagKey
------
host
instance

name: host_metrics_micro
tagKey
------
host
instance

name: unknown
tagKey
------
host
instance
```

```
> show field keys from container_metrics
name: container_metrics
fieldKey                               fieldType
--------                               ---------
blkio_io_service_bytes_recursive_async float
blkio_io_service_bytes_recursive_read  float
blkio_io_service_bytes_recursive_sync  float
blkio_io_service_bytes_recursive_total float
blkio_io_service_bytes_recursive_write float
cpu.percent_value                      float
cpu.usage_kernelmode                   float
cpu.usage_system                       float
cpu.usage_total                        float
cpu.usage_usermode                     float
cs                                     float
interval                               float
cycles                                 float
memory.usage_limit                     float
instructions                           float
memory.usage_max                       float
memory.usage_total                     float
network.usage_eth0_rx_bytes            float
network.usage_eth0_rx_dropped          float
network.usage_eth0_rx_errors           float
network.usage_eth0_rx_packets          float
network.usage_eth0_tx_bytes            float
network.usage_eth0_tx_dropped          float
network.usage_eth0_tx_errors           float
network.usage_eth0_tx_packets          float
page-faults                            float
network.usage_eth1_rx_bytes            float
network.usage_eth1_rx_dropped          float
network.usage_eth1_rx_errors           float
network.usage_eth1_rx_packets          float
network.usage_eth1_tx_bytes            float
network.usage_eth1_tx_dropped          float
network.usage_eth1_tx_errors           float
network.usage_eth1_tx_packets          float


> show field keys from host_metrics
name: host_metrics
fieldKey                      fieldType
--------                      ---------
contextswitch                 float
cpu                           float
cs                            float
disk_io_time_io_time          float
disk_io_time_weighted_io_time float
disk_octets_read              float
disk_octets_write             float
if_dropped_rx                 float
if_dropped_tx                 float
if_errors_rx                  float
if_errors_tx                  float
if_octets_rx                  float
if_octets_tx                  float
if_packets_rx                 float
if_packets_tx                 float
interval                      float
kvm_exit                      float
major-faults                  float
memory                        float
page-faults                   float
rx                            float
sched_stat_iowait             float
sched_stat_wait               float
tx                            float
sched_switch                  float

> show field keys from host_metrics_micro
name: host_metrics_micro
fieldKey                fieldType
--------                ---------
CPI                     float
interval                float
l1_2_bw                 float
l1_l2_totaldata         float
l2_3_bw                 float
l2_l3_totaldata         float
l3_bw                   float
l3_system_totaldata     float
mem_bw                  float
memory_data             float
L1-dcache-load-misses   float
L1-dcache-loads         float
L1-dcache-stores        float
L1-icache-load-misses   float
LLC-load-misses         float
LLC-loads               float
LLC-store-misses        float
LLC-stores              float
alignment-faults        float
branch-load-misses      float
branch-loads            float
branch-misses           float
branches                float
bus-cycles              float
cache-misses            float
cache-references        float
context-switches        float
cpu-clock               float
cpu-cycles              float
cpu-migrations          float
dTLB-load-misses        float
dTLB-loads              float
dTLB-store-misses       float
dTLB-stores             float
emulation-faults        float
iTLB-load-misses        float
iTLB-loads              float
instructions            float
l2_rqsts.code_rd_hit    float
l2_rqsts.code_rd_miss   float
major-faults            float
minor-faults            float
page-faults             float
task-clock              float
cpufreq_gpu_clock_value float
cpufreq_mem_clock_value float
memory_total_value      float
memory_used_value       float
percent_dec_util_value  float
percent_enc_util_value  float
percent_gpu_util_value  float
percent_mem_util_value  float
power_power_draw_value  float
temperature_value       float

> show field keys from host_gpu_metrics
name: host_gpu_metrics
fieldKey                fieldType
--------                ---------
cpufreq_gpu_clock_value float
cpufreq_mem_clock_value float
interval                float
memory_total_value      float
memory_used_value       float
percent_dec_util_value  float
percent_enc_util_value  float
percent_gpu_util_value  float
percent_mem_util_value  float
power_power_draw_value  float
temperature_value       float

```

