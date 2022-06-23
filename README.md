# <p><center>Obligatorio Aplicaciones Cloud 2022</center></p>

## Integrantes

Santiago Banfi 144736

Santiago Regina 177065


## Detalles Técnicos

*Versión de Terraform:* v1.1.9

*Versión de Kubectl:* Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.0", GitCommit:"c2b5237ccd9c0f1d600d3072634ca66cefdf272f", GitTreeState:"clean", BuildDate:"2021-08-04T18:03:20Z", GoVersion:"go1.16.6", Compiler:"gc", Platform:"linux/amd64"}

*Versión de Docker:* Docker version 20.10.15, build fd82621

*Servicios de AWS utilizados:* VPC, EKS, ECR, EC2. 


## Datos de infraestructura

*Tipo de instancias:* t3.large

*Bloques CIDRs:* 
  - Subnet Privada 1 - 10.0.128.0/20
  - Subnet Privada 2 - 10.0.144.0/20
  - Subnet Publica 1 - 10.0.0.0/20
  - Subnet Publica 2 - 10.0.16.0/20

*Firewalling*
  - Security Group - Todo el tráfico habilitado dentro del cluster
  - Security Group - Se expone el puerto 80 hacia internet desde el cluster


## Automatización

*Se utilizó terraform para la creación de:*
VPC - obligatorio-vpc
Subnets
  - obligatorio-subnet-private1
  - obligatorio-subnet-private2
  - obligatorio-subnet-public1
  - obligatorio-subnet-public2
Internet Gateway - obligatorio-igw
Route Tables
  - obligatorio-pravate1
  - obligatorio-pravate2
  - obligatorio-public
Cluster EKS - obligatorio
Nodos EKS - workersobli

## Manualmente

Registros de imágenes en ECR:
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/adservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/cartservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/checkoutservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/currencyservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/emailservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/frontend
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/loadgenerator
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/paymentservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/productcatalogservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/recommendationservice
  - 170695521185.dkr.ecr.us-east-1.amazonaws.com/shippingservice
  
Creación de las imágenes y subirlas a los registros correspondientes.

Posicionados dentro de las carpetas de cada micro servicio, se ejecuta el comando:

*docker build -t "nametag" .*

Por ejemplo para el micro servicio "adservice" se ejecutó "docker build -t adservice . "

Luego de creada la imagen, se ejecutaron los siguientes comandos para subir la imagen al registro.
 
*aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 170695521185.dkr.ecr.us-east-1.amazonaws.com*
 
*docker tag adservice:latest 170695521185.dkr.ecr.us-east-1.amazonaws.com/adservice:latest*
 
*docker push 170695521185.dkr.ecr.us-east-1.amazonaws.com/adservice:latest*
 
De esta forma la imagen ya quedo en el registro, pronta para ser utilizada.

Por último se modificó en cada archivo kubernetes-manifests.yaml la dirección de la imagen en el elemento "image:" por la dirección de los registros

Ejemplo: *image: 170695521185.dkr.ecr.us-east-1.amazonaws.com/adservice:latest*

  
*Deployment de los micro servicios en los pods*

Posicionados en las carpetas deployment de cada micro servicio se ejecutó "kubectl create -f kubernetes-manifests.yaml" 
  


