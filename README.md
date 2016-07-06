 Declaraciones Juradas Abiertas - Front
=======================================
Declaraciones Juradas Abiertas es un proyecto de [LA NACION](http://lanacion.com.ar), junto a Poder Ciudadano, Fundación Directorio Legislativo, la Asociación Civil por la Igualdad y la Justicia y más de 30 voluntarios que colaboraron para abrir la información patrimonial de los principales funcionarios públicos de la Argentina.
Todas las personas que participamos del proyecto queremos que otras organizaciones y equipos se sumen a la aventura de abrir documentos públicos que no puedan ser procesados (aún) por las tecnologías disponibles. Con este mismo espíritu y gracias al apoyo de Hivos, creamos este formulario que nos permitió cargar de manera colaborativa más de 900 declaraciones juradas nuevas, luego del lanzamiento inicial en 2013.
Estamos convencidos de que abrir el código de esta aplicación permitirá a otros hacer más fácil la tarea de crear bases de datos para acercar la información pública a los ciudadanos. Por eso también, invitamos (y queremos) que otras personas puedan descargar , modificar y retrabajar lo que hicimos en equipo.
Por último, agradecemos a [Suma Ciudadana](http://www.sumaciudadana.org/), ONG de Perú con la que trabajamos durante más de un año en el marco del proyecto de [Hivos](https://www.hivos.org/) para impulsar y mejorar nuestras platafromas de declaraciones juradas. Juntos nos enfrentamos a desafíos que pudimos resolver colectivamente, pero por sobre todas las cosas, hicimos las cosas en equipo con una única finalidad: que las personas pudieron conocer el patrimono de los funcionarios públicos sin tecnicismos y de modo sencillo.


## Para instalar Xapian en Ubuntu
  
  Antes de `bundle install` hacer:

  `sudo apt-get install libxapian-dev libxapian22 uuid-dev`

  Se recomienda usar [_rbenv_](https://github.com/sstephenson/rbenv) y [_rbenv-bundler_](https://github.com/carsomyr/rbenv-bundler)
  

## Configuración de la aplicación

* Duplicar __config/database.yml.example__ y y renombrar a  __"config/database.yml"__
* Abrir __"config/database.yml"__ y configurar la base de datos
* Duplicar __config/initializers/basic_authenticate.rb.example__ y renombrar a  __"config/initializers/basic_authenticate.rb"__ \(Simple login para el admin\)
* Instalar gemas `$ bundle install`
* Correr las migraciones: `$ rake db:migrate`
* Correr el server: `$ rails s`

  
## Para actualizar el indice de busqueda

  `rake ddjj:load_index`
  ` RAILS_ENV=production rake ddjj:load_index`


## Para actualizar los assets

	'rake assets:precompile'
 
## Crear csv para exportar de los 3 poders

  `GET tareas/crear_csv_poderes`


## Actualizar los DNI

Recibe un CSV separedo por ",". El mismo debe estar en `public/dni_personas.csv`, hay que subirlo por ftp.

Elcon orden de las cabeceras es el siguiente:

`["apellido", "nombre", "CUIL", "DNI", "CUIT"]`

Donde "apellido" es la primer fila, "nombre" la segunda, y asi sin alterar el orden
Para ejecutar el script acceder al menú del admin "Tareas" > "load_dnis para personas"


<img src="http://blogs.lanacion.com.ar/data/files/2015/08/HIVOS-2.jpg" width="350">
