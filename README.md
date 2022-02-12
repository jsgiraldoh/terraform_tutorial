Despliegue de MEAN multicapa mediante Terraform
===

**Objetivos**

En esta actividad aprenderás a utilizar Terraform con un ejemplo sencillo pero completo. Para ello, usaremos una stack MEAN con dos o más máquinas. A través de esta actividad conseguirás familiarizarte con la herramienta Terraform para desplegar conjuntos de componentes que se comuniquen entre ellos.

**Pautas de elaboración**

Debemos crear una template (plantilla) de Terraform que permita desplegar una stack MEAN en dos o más máquinas.

El despliegue se hará en alguna nube pública: AWS, Google o Azure. La opción más recomendada es AWS y la documentación aportada se basa en esta nube. Se desplegará al menos una máquina que ejecute Nginx y Node.js y que incluya la aplicación, y una segunda máquina con MongoDB. Puedes generar la primera con Packer y además podrás reutilizar (si así lo deseas) la imagen generada en la primera práctica.

Para realizar la práctica partiremos desde esta guía:

https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/

Desarrollo
===

Como se abordo la solución de este requerimiento:

1. El primer paso fue instalar el binario de aws cli:
    https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    
2. El segundo paso fue instalar el binario de terraform:
 https://www.terraform.io/downloads
 
3. El tercer paso consite en configurar el archivo credentials dentro del home de usuario en el directorio **.aws/crendentials**.

<img src="/img/1.png" title="1.png" name="1.png"/><br>

4. También se pueden exportar las credenciales de tú cuenta de amazón, para que la cli funcione correctamente.

    ~~~
    export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
    ~~~

5. Luego utilizamos la guía de ejemplo de terraform y usamos el ejemplo que se encontraba en la página.

**Single EC2 Instance**

~~~
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
~~~

Teniendo en cuenta que no se sabia como se iba a comportar la ejecución del archivo .tf y no se entendia como crear **vpc_security_group** y **subnet**. Se decido usar los elementos anteriormente mencionados por defecto cuando se inicia en una cuenta de aws.

6. Para poder entender como es la estructura y ejecución del comando terraform, ejecutamos el comando:

    ~~~
    terraform -help
    ~~~

    <img src="/img/2.png" title="2.png" name="2.png"/><br>

7. Inicialice el proyecto, que descarga un complemento que permite que Terraform interactúe con aws.

    ~~~
    terraform init
    ~~~
    
8. Teniendo en cuenta las opciones ilustradas por el comando **terraform -help**, usamos el comando:

    ~~~
    terraform plan
    ~~~

    <img src="/img/3.png" title="3.png" name="3.png"/><br>

    Para verificar la sintaxis del archivo y observar que elementos van ha ser creados y los posibles errores que pueda arrojar.

9. Para lanzar la ejecución utilizamos el siguiente comando:

    ~~~
    terraform apply
    ~~~

    <img src="/img/4.png" title="4.png" name="4.png"/><br>

10. Para crear la llave, se utilizo el siguiente comando:
    
    ~~~
    ssh-keygen -m pem -b 4096 -f tf_key.pem
    ~~~

11. Luego que se construyo la infraestructura de prueba y despues de varios intentos, se logro establecer una llave para acceder a la instancia con el siguiente tutorial.

    https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws/latest
    
    Nota: no fue posible establecer el modulo de la llave de la instancia en el mismo archivo que se despliegue de EC2.
    
12. Luego de usar más la técnologia, se procedio a inicar con la solución del objetivo. 

    Lo que se hizo fue usar un archivo de packer para construir una **AMI** de **amazon** que contuviera el software del **front-end** en este caso **node**. Esta **AMI** también contiene la configuración de un **proxy inverso** que permite desplegar un sitio estatico en **javascript**.
    
    Diríjase al siguiente tutorial para entender toda la solución propuesta con packer.
    
    https://github.com/jsgiraldoh/packer_tutorial

    <img src="/img/9.png" title="9.png" name="9.png"/><br>
    
13. Posteriormente luego de crear el AMI y obtener el ID, se inicio el desarrollo del archivo **ec2_instance.tf**.

    Por otro lado se investigo el ID de una base de datos **mongo** el cual fue el siguiente: **ami-0011964644468a877**
    
    Y el resultado fue el siguiente:
    
~~~
provider "aws" {
	region = "us-west-2"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "Packer Builder"

  ami                    = "ami-070c2b9448b7e5fe7"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["sg-0f3df87f16ee2cd9a"]
  subnet_id              = "subnet-0d8479eefe63e0056"
  key_name   = "tf_key"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  } 

}

module "ec2_instancedb" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "Mongo DB"

  ami                    = "ami-0011964644468a877"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["sg-0f3df87f16ee2cd9a"]
  subnet_id              = "subnet-0d8479eefe63e0056"
  key_name   = "tf_key"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
~~~

14. Para ejecutar los archivos usamos el comando

    ~~~
    terraform apply -auto-approve
    ~~~

    <img src="/img/8.png" title="8.png" name="8.png"/><br>

15. Observamos todos los elementos creados en AWS.

    <img src="/img/5.png" title="5.png" name="5.png"/><br>

    <img src="/img/6.png" title="6.png" name="6.png"/><br>

    <img src="/img/7.png" title="7.png" name="7.png"/><br>

    <img src="/img/13.png" title="13.png" name="13.png"/><br>

    <img src="/img/14.png" title="14.png" name="14.png"/><br>

    <img src="/img/15.png" title="15.png" name="15.png"/><br>

16. Ingresamos a la instancia del **front-end**.

    <img src="/img/14.png" title="14.png" name="14.png"/><br>

17. Creamos nuestro archivo **javascript** con el siguiente comando:

    ~~~
    vim hello.js
    ~~~

    <img src="/img/21.png" title="21.png" name="21.png"/><br>

18. Debemos adicionar el siguiente código:

~~~
const http = require('http');
const hostname = 'localhost';
const port = 3000;

var MongoClient = require('mongodb').MongoClient;
var url = 'mongodb://34.221.74.165:27017/test';

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end(`url: `+ url);	
	
  MongoClient.connect(url, function(err, db) {
    console.log(db);
  });	
});


server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
~~~

19. Para poder ejecutar código **js** con los modulos de mondo debemos ejecutar el comando.

    ~~~
    npm install mongodb --save
    ~~~

    <img src="/img/11.png" title="11.png" name="11.png"/><br>
    
20. Luego ejecutamos nuestro archivo **js**, el cual va a prestar un servicio http.

    ~~~
    node hello.js
    ~~~

    <img src="/img/10.png" title="10.png" name="10.png"/><br>
  
21. Resultados de ejecutar la petición por el **browser**:

    <img src="/img/18.png" title="18.png" name="18.png"/><br>

    <img src="/img/20.png" title="20.png" name="20.png"/><br>

    <img src="/img/19.png" title="19.png" name="19.png"/><br>

22. Probando conexión desde la instancia del **back-end**, hacien el front-end**.

    ~~~
    sudo apt install mongodb-clients
    ~~~

    <img src="/img/17.png" title="17.png" name="17.png"/><br>

    ~~~
    mongo -p 27017 34.221.74.165
    ~~~

    <img src="/img/16.png" title="16.png" name="16.png"/><br>