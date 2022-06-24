# <p><center>Obligatorio Aplicaciones Cloud 2022</center></p>

## Integrantes

Santiago Banfi 144736

Santiago Regina 177065


## Detalles Técnicos

*Versión de Terraform:* v1.1.9

*Versión de Kubectl:* Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.0", GitCommit:"c2b5237ccd9c0f1d600d3072634ca66cefdf272f", GitTreeState:"clean", BuildDate:"2021-08-04T18:03:20Z", GoVersion:"go1.16.6", Compiler:"gc", Platform:"linux/amd64"}

*Versión de Docker:* Docker version 20.10.15, build fd82621

*Servicios de AWS utilizados:* VPC, EKS, ECR, EC2. 

## Diagrama de arquitectura



![Obligatorio_Cloud drawio](https://user-images.githubusercontent.com/52022499/175193870-cbba73d6-0c05-4ec4-8aaf-de3db49914c8.png)


**Online Boutique** está compuesto por 11 microservicios escritos en diferentes idiomas que se comunican entre sí a través de gRPC. 

![architecture-diagram](https://user-images.githubusercontent.com/52022499/175436247-dbde24b9-df32-4220-b39e-39294c803de1.png)


**Online Boutique** es una aplicación de demostración de microservicios nativa de la nube.
Online Boutique consta de una aplicación de microservicios de 10 niveles. La aplicación es un
aplicación de comercio electrónico basada en la web donde los usuarios pueden buscar artículos,
añadirlos al carrito y compralos.


## Imagenes

| Home Page                                                                                                         | Checkout Screen                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| ![online-boutique-frontend-1](https://user-images.githubusercontent.com/52022499/175436082-e2a3a121-7d28-45e0-a196-a5b305f164c0.png) | ![online-boutique-frontend-2](https://user-images.githubusercontent.com/52022499/175436167-3825bb1b-a65e-480e-905f-9b573c2775da.png) |




| Service                                              | Language      | Description                                                                                                                       |
| ---------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [frontend](./src/frontend)                           | Go            | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically. |
| [cartservice](./src/cartservice)                     | C#            | Stores the items in the user's shopping cart in Redis and retrieves it.                                                           |
| [productcatalogservice](./src/productcatalogservice) | Go            | Provides the list of products from a JSON file and ability to search products and get individual products.                        |
| [currencyservice](./src/currencyservice)             | Node.js       | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| [paymentservice](./src/paymentservice)               | Node.js       | Charges the given credit card info (mock) with the given amount and returns a transaction ID.                                     |
| [shippingservice](./src/shippingservice)             | Go            | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock)                                 |
| [emailservice](./src/emailservice)                   | Python        | Sends users an order confirmation email (mock).                                                                                   |
| [checkoutservice](./src/checkoutservice)             | Go            | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification.                            |
| [recommendationservice](./src/recommendationservice) | Python        | Recommends other products based on what's given in the cart.                                                                      |
| [adservice](./src/adservice)                         | Java          | Provides text ads based on given context words.                                                                                   |
| [loadgenerator](./src/loadgenerator)                 | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend.                                              |


## Datos de infraestructura

*Tipo de instancias:* t3.medium

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

Para la ejecución de la automatización nos posicionamos en la carpeta terraformobli y ejecutamos

*terraform init* para inicializar el ambiente de trabajo en esa carpeta.

*terraform plan* para que analice el contenido de los archivos a ejecutar y nos presente un resumen de los cambios que va a realizar

*terraform apply* sumado a lo anterior nos da la opción de aplicar los cambios, si contestamos con "yes"

Al contestar "yes" se ejecutan las diferentes automatizaciones y una vez finalizado podemos corroborarlo en AWS.


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
  


