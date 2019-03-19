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

