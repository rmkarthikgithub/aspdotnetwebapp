=================================================================================================
# STEPS TO BE FOLLOWED - BUILDING A DOCKER IMAGE
=================================================================================================

# DOCKER BUILD 
        $ sudo su
        $ cd
        $ sudo apt-get update -y
        $ sudo apt-get install docker.io -y
        $ git clone https://github.com/azonecloud/aspdotnetwebapp.git
        $ cd aspdotnetwebapp.git
        $ docker build -t  calphaacr.azurecr.io/aspdotnetwebapp:latest .
        $ docker login calphaacr.azurecr.io [# username and password are available under Azure ACR -> Repository]
        $ docker push calphaacr.azurecr.io/aspdotnetwebapp:latest

# KUBECTL INSTALLATION
        $ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        $ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# AKS INSTALLATION
        $ az aks create -g myResourceGroup -n myAKSCluster --enable-managed-identity --node-count 1 --enable-addons monitoring --enable-msi-auth-for-monitoring  --generate-ssh-keys

=================================================================================================
# STEPS TO BE FOLLOWED - Deploy ASP.NET Docker Image along with MS SQL EDGE
=================================================================================================
# Create a kubernetes namespace for SQL Edge deployment
        $ kubectl create namespace <namespace name>

# Create an SA password
        $ kubectl create secret generic mssql --from-literal=SA_PASSWORD="MyC0m9l&xP@ssw0rd" -n <namespace name>

# Create and Configure a persistent volume and persistent volume claim in the Kubernetes cluster. 
    - Create a manifest to define the storage class and the persistent volume claim
    - Manifest specifies the storage provisioner, parameters, and reclaim policy
    - Kubernetes cluster uses this manifest to create the persistent storage
    - Storage class provisioner is azure-disk, because this Kubernetes cluster is in Azure
    - Storage account type is Standard_LRS
    - Persistent volume claim is named mssql-data
    - Persistent volume claim metadata includes an annotation connecting it back to the storage class

# Create the Persistent Volume(PV) and Persistent Volume Claims(PVC) in Kubernetes.
    - kubectl apply -f <path-to-persisentvolume.yaml>
        $ kubectl apply -f mssqledge-persistentvolume.yaml

# Get and describe about Persistent Volumes and Persistent Volume Claims
        $ kubectl get pv
        $ kubectl get pvc
        $ kubectl describe pv
        $ kubectl describe pvc

# Create the deployment for Azure SQL Edge
    - kubectl apply -f <Path to mssqledge-deployment.yaml file>
        $ kubectl apply -f mssqledge-deployment.yaml
        $ kubectl get deployments
        $ kubectl get pods
    
# Create Service for Azure SQL Edge :
    - kubectl apply -f <path-az-sql-edge-service.yaml>
        $ kubectl apply -f mssqledge-service.yaml
        $ kubectl get svc
        $ kubectl describe svc mssqledge-service

# To Get Services ,Secrets:
        $ kubectl get secrets
        $ kubectl get configmaps
        $ kubectl get pv
        $ kubectl get pvc
        $ kubectl get deploy
        $ kubectl get pods
        $ kubectl get svc

# Connect to the Azure SQL Edge instance
        $ kubectl get pods -n <namespace name>
        $ kubectl get svc

    - Service will expose an External IP

# SQL DATABASE CREATION AND INSERTION OF DATA
- Using Azure Data Studio ,Connect to Databases using External IP
        $ CREATE TABLE emp(empid INT,ename VARCHAR(60));
        $ INSERT INTO dbo.emp VALUES(1,'Kumar');
        $ INSERT INTO dbo.emp VALUES(2,'Kumara');
        $ INSERT INTO dbo.emp VALUES(3,'Kumaran');
        $ SELECT * FROM dbo.emp;
        $ DROP TABLE dbo.emp;

# To Verify the Persistence of Data across Kubernetes Volumes 
    - Delete the Kubernetes Pods
    - Kubernetes automatically re-creates the pod to recover an Azure SQL Edge instance
    - Connect to the persistent storage
    - Use kubectl get pods to verify that a new pod is deployed
    - Use kubectl get services to verify that the IP address for the new container is the same
    
        $ kubectl get pods
        $ kubectl delete pod <mssqledge-pods>

# To Delete Pods , Volumes, Secrets, configmaps:
        $ kubectl delete secrets <mssqledge-secrets>
        $ kubectl delete storageclass <mssqledge-storageclass>
        $ kubectl delete pv <mssqledge-pv>
        $ kubectl delete pvc <mssqledge-pvc>
        $ kubectl delete configmaps <mssqledge-configmaps>
        $ kubectl delete deploy <mssqledge-deployment>
        $ kubectl delete svc <sqledge-deployment>
        $ kubectl delete svc <aspdotnetwebpp-service>
        $ kubectl delete deploy <aspdotnetwebpp-deployment>
        $ kubectl delete svc <mssqledge-service>

# To Delete Cluster
       $ az group delete --name myResourceGroup --yes --no-wait






























