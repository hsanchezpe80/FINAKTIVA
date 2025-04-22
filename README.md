
Infraestructura como Código para Cluster Fargate en AWS
Este proyecto implementa un clúster de AWS Fargate con alta disponibilidad utilizando Terraform como herramienta de Infraestructura como Código (IaC) y GitLab para la implementación de CI/CD.
Arquitectura del Proyecto
Show Image
La arquitectura implementada consta de:

VPC personalizada con subredes públicas y privadas distribuidas en múltiples zonas de disponibilidad
Clúster ECS Fargate para ejecución de contenedores sin administración de servidores
ECR para almacenamiento de imágenes Docker
ALB (Application Load Balancer) para distribución de tráfico HTTPS (puerto 443)
AWS Certificate Manager para gestión de certificados SSL/TLS
Security Groups para control de acceso basado en IP
CloudWatch para monitoreo y configuración de alarmas para auto-escalado

Elección de Herramientas
Terraform vs AWS CDK
Aunque el desafío sugiere AWS CDK, he elegido Terraform por las siguientes razones:
Ventajas de Terraform:

Independencia del proveedor: Permite trabajar con múltiples proveedores de nube, facilitando arquitecturas multi-cloud
Estado declarativo: Mayor facilidad para entender el estado actual y deseado de la infraestructura
Gran comunidad y documentación: Amplia adopción en la industria con numerosos módulos reutilizables
Abstracción de APIs: No requiere conocimiento profundo de SDKs específicos

Desventajas de Terraform:

No permite programación orientada a objetos como CDK
Gestión de estado puede ser compleja en equipos grandes (aunque se resuelve con backend remoto)
No se integra tan naturalmente con herramientas de AWS como CDK

GitLab CI/CD
Ventajas:

Integración completa: Sistema todo-en-uno con control de código, CI/CD y gestión de artefactos
Pipeline como código: Permite versionar la configuración de despliegue junto con el código
Variables de entorno seguras: Gestión robusta de secretos y configuraciones por entorno
Runners auto-escalables: Puede escalar automáticamente para manejar cargas de trabajo variables

Desventajas:

Mayor complejidad en comparación con sistemas más simples como GitHub Actions
Puede requerir recursos dedicados para ejecutar los runners

Estructura del Proyecto
.
├── README.md
├── docs/
│   └── architecture.png
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   │   └── terraform.tfvars
│   │   ├── stg/
│   │   │   └── terraform.tfvars
│   │   └── prod/
│   │       └── terraform.tfvars
│   ├── modules/
│   │   ├── networking/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── ecs/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── ecr/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── lb/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── security/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
├── apps/
│   ├── app1/
│   │   ├── Dockerfile
│   │   └── src/
│   └── app2/
│       ├── Dockerfile
│       └── src/
└── .gitlab-ci.yml
Requisitos Previos

Cuenta de AWS con permisos administrativos
Terraform v1.0.0 o superior
GitLab Runner configurado
AWS CLI configurado localmente para pruebas

Configuración
1. Variables de Entorno
Configura las siguientes variables de entorno en GitLab CI/CD:

AWS_ACCESS_KEY_ID: Clave de acceso para AWS
AWS_SECRET_ACCESS_KEY: Clave secreta para AWS
TF_VAR_allowed_ips: Lista de IPs permitidas para acceso (Formato CSV)

2. Configuración de Entornos
Edita los archivos terraform/environments/*/terraform.tfvars para configurar los parámetros específicos de cada entorno como:

CIDR blocks para VPC y subredes
Número de tareas por servicio
Tipo de despliegue (blue/green, rolling, etc.)
Umbral de CPU para auto-escalado



API Service (app1):

Un servidor Express básico con solo un endpoint de datos y health check
Solo utiliza express como dependencia
Responde con datos de ejemplo simples


Worker Service (app2):

Un servidor Flask básico con un endpoint de procesamiento simple
Solo utiliza flask y gunicorn para producción
Simula procesamiento con un simple sleep



Ambas aplicaciones tienen:

Un endpoint principal /
Un endpoint /health para los health checks de AWS
Un endpoint de API funcional simple
Configuración mínima para ejecutarse

/FINAKTIVA

README.md: Documentación principal del proyecto

/apps

/app1

src/server.js: Código de la API en Node.js
package.json: Dependencias de Node.js
Dockerfile: Para construir la imagen de la app1


/app2

app.py: Código del Worker en Python
requirements.txt: Dependencias de Python
Dockerfile: Para construir la imagen de la app2



/terraform-iac

main.tf: Archivo principal de Terraform
variables.tf: Definición de variables
outputs.tf: Outputs del despliegue
backend53.tf: Configuración del backend S3
/ambientes

/dev/terraform.tfvars: Variables para desarrollo (Ohio)
/stg/terraform.tfvars: Variables para staging (Virginia)
/prod/terraform.tfvars: Variables para producción (Oregon)



login ecr

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-2.amazonaws.com
