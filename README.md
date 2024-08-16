# clickHouseByAnsible
this repo is about how you can provision the clickhouse cluster with the help of Ansible.
There is lot of manual work involved if you are setting up the multinode clickhouse cluster.
  update the worker config files with respective worker IP addresses.
  update the node config files with sensitive info, worker IPs, weightage, user config details., etc..
Thanks to Claude and ChatGPT, major part of this solution is generated but perfectly working solution. not only that, it is iterative, i.e, you can improve this solution as per requirements.

here is the workflow about how it works.
1. Launch a VM in GCP
2. Follow this link to install CH on ubuntu: https://clickhouse.com/docs/en/install#install-from-deb-packages (Its very simple)
3. Attach the additional disk if necessary(most probably Devs working with this cluster would require the additional disk apart from boot disk.)
4. both CH client and server will be installed as systemd agents, disable both for now. (you will know why later)
5. stop the VM and take the Machine Image at this point in time.
6. we assume that network and subnetwork are already created and we just gonna refer them while creating the cluster.
7. Although Ansible documenation is sh*t as of this commit(16 aug 2024), I still came working around.
8. we use Jenkins(it was just in our to use it, you can use any other platform to do this) to take inputs from user like: number of keepers and nodes, team name for which cluster is created and cluster name. xml file is at root path of this repo, you can directly copy that files and place it file: /var/lib/jenkins/jobs/<project_name>/config.xml and reload the jenkins.
9. before running the playbook, we put a small logic to handle the case where user should not use cluster name for more than one cluster. and get the secrets from GCP secret manager.
10. Then we run the playbook which creates the VMs based on machine Imae that we took earlier, generate the keeper, node, and node_user config from templates, copy them to remote VMs we jsut created.
11. Finally, remember we disabled both CH client and server ?, now we enable the keeper on keeper nodes only and enable the node on node VMs only.
12. restart the CH and cleanup the temporary files.
13. your ClickHouse cluster is ready.
  
