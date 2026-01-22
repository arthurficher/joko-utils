# Ejercicio práctico - DevOps-001
# Gestión de Java con SDKMAN! y pipeline local con Maven utilizando joko-utils

---

## Preparación del entorno con SDKMAN!

### Investigación
SDKMAN! es una herramienta de gestión de versiones para facilitar el cambio entre distintos SDKs (Software Development Kits) en entornos Unix/Linux. Permite instalar, administrar y alternar entre múltiples versiones de Java y otras herramientas del ecosistema JVM.

### Pasos realizados

1. **Instalación de SDKMAN!:** Se procedió a la instalación mediante curl y se inicializaron los scripts necesarios en la terminal.
2. **Listado y Selección:** Se listaron las versiones de Java disponibles y se analizó la tabla de proveedores y versiones.
3. **Elección de versión LTS:** Se seleccionó la versión **Java 17 (Eclipse Temurin)**.
   - **Justificación:** Se eligió porque es una versión **LTS (Long-Term Support)**, lo que garantiza estabilidad, soporte extendido de seguridad y es el estándar actual en la industria para el desarrollo de aplicaciones modernas.
4. **Instalación del JDK:** Se descargó e instaló la versión `17.0.17-tem`.
5. **Configuración de Entorno (Resolución de conflicto):** Debido a que el sistema operativo tenía una versión de Java 8 preinstalada en `/opt` con prioridad alta (por software bancario), se configuró manualmente la variable `PATH` en la sesión actual para priorizar la nueva versión de Java 17 sin afectar la configuración global del sistema.
6. **Verificación:** Se confirmó que el comando `java -version` apuntara a la versión instalada por SDKMAN!.

### Comandos utilizados

```bash
# 1. Descarga e instalación de SDKMAN!
curl -s "https://get.sdkman.io" | bash

# 2. Carga de las variables de entorno de SDKMAN!
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 3. Verificación de la versión de SDKMAN!
sdk version

# 4. Listado de versiones disponibles de Java
sdk list java

# 5. Instalación de la versión LTS seleccionada (Java 17 Temurin)
sdk install java 17.0.17-tem

# 6. Forzado de la variable PATH (necesario por conflicto con Java 8 en /opt)
export PATH="$HOME/.sdkman/candidates/java/17.0.17-tem/bin:$PATH"

# 7. Verificación final de que el sistema usa Java 17
java -version
```

### Versiones finalmente configuradas

**Gestor de versiones:** SDKMAN! 5.20.0

**Java Development Kit (JDK):**
* **Versión:** OpenJDK 17.0.17
* **Distribución:** Temurin (Eclipse Adoptium)
* **Identificador en SDKMAN:** 17.0.17-tem

---

## Instalación de Maven desde el repositorio oficial de Ubuntu

### Forma de instalación
Se procedió a instalar Apache Maven utilizando el gestor de paquetes nativo de Ubuntu.

* **Paquete utilizado:** `maven` (repositorio oficial de Ubuntu)
* **Comando de instalación:** `sudo apt install maven`

### Versión de Maven instalada

**Apache Maven 3.8.7**
* Maven home: `/usr/share/maven`

### Evidencia de integración con SDKMAN!

Se verificó que Maven está utilizando el entorno Java gestionado por SDKMAN! y no el Java del sistema operativo.

#### Salida del comando `mvn -version`:
```
Apache Maven 3.8.7
Maven home: /usr/share/maven
Java version: 17.0.17, vendor: Eclipse Adoptium, runtime: /home/sysadmin/.sdkman/candidates/java/17.0.17-tem
Default locale: es_ES, platform encoding: UTF-8
OS name: "linux", version: "6.14.0-36-generic", arch: "amd64", family: "unix"
```

**Confirmación:** Maven del sistema utiliza correctamente el `JAVA_HOME` configurado por SDKMAN!.

---

## Obtención y exploración del proyecto joko-utils

### Clonado del repositorio

* **Comando:** `git clone https://github.com/JokoFramework/joko-utils.git`
* **Directorio de trabajo:** `/home/sysadmin/Documentos/proyectos/devops/joko-utils`
* **Nota:** El archivo `NOTAS_DEVOPS.md` ha sido creado en la raíz del proyecto clonado.

### Ubicación del pom.xml

El archivo `pom.xml` se encuentra en la **raíz del proyecto**. Este archivo es el núcleo de la configuración de Maven (Project Object Model).

### Estructura de directorios principales

El proyecto sigue la estructura estándar de Maven ("Standard Directory Layout"):

* **`src/main/java`:** Contiene el código fuente de la aplicación (la lógica del framework).
* **`src/test/java`:** Contiene los tests unitarios (importante para la fase de `test` del pipeline).

### Referencias a procesos de Integración Continua

Durante la exploración con `ls -la`, se identificó la existencia de configuraciones de CI:

* **Herramienta detectada:** GitHub Actions
* **Ubicación:** Directorio oculto `.github/workflows/`
* **Archivos encontrados:** `maven.yml`
* **Conclusión:** El proyecto ya cuenta con una definición remota para compilar y testear el código cada vez que se hace un push al repositorio.

---

## Simulación de pipeline CI local con Maven

Se ejecutaron manualmente las fases estándar del ciclo de vida de Maven para validar el funcionamiento del proyecto y entender el flujo de construcción.

### Ejecución de Fases (Bitácora)

#### 1. Limpieza (Clean)
* **Comando:** `mvn clean`
* **Objetivo:** Eliminar artefactos de compilaciones previas
* **Resultado:** ✅ `BUILD SUCCESS`
* **Detalle:** Se eliminó el directorio `/home/sysadmin/Documentos/proyectos/devops/joko-utils/target`

#### 2. Validación (Validate)
* **Comando:** `mvn validate`
* **Objetivo:** Validar la estructura y configuración del proyecto
* **Resultado:** ✅ `BUILD SUCCESS`
* **Tiempo:** 0.836 s

#### 3. Compilación (Compile)
* **Comando:** `mvn compile`
* **Objetivo:** Compilar el código fuente de `src/main/java`
* **Resultado:** ✅ `BUILD SUCCESS`
* **Detalle:** Se compilaron **19 archivos fuente** en `target/classes`
* **Nota:** Se observaron advertencias (warnings) sobre uso de APIs deprecadas en `ReflectionUtils.java` y operaciones no seguras en `BaseEntity.java`. Esto es normal en código legado, pero no detiene la compilación.

#### 4. Pruebas (Test)
* **Comando:** `mvn test`
* **Objetivo:** Ejecutar pruebas unitarias
* **Resultado:** ✅ `BUILD SUCCESS`
* **Resumen de Tests:**
  - **Ejecutados:** 7
  - **Fallos:** 0
  - **Errores:** 0
  - **Tiempo total:** ~32.6 s (debido principalmente a `UUIDGenerationTest` que toma 30s)

#### 5. Empaquetado (Package)
* **Comando:** `mvn package`
* **Objetivo:** Empaquetar el código compilado y probado en un archivo JAR
* **Resultado:** ✅ `BUILD SUCCESS`
* **Resumen de Tests:**
  - **Ejecutados:** 7
  - **Fallos:** 0
  - **Errores:** 0
  - **Tiempo total:** ~32.6 s

### Verificación del Artefacto Generado

Tras finalizar la fase de `package`, se verificó la existencia del entregable final:

* **Nombre del artefacto:** `joko-utils-0.6.9.jar`
* **Ruta completa:** `/home/sysadmin/Documentos/proyectos/devops/joko-utils/target/joko-utils-0.6.9.jar`

---

## Creación de un script de pipeline local

### Script de Automatización (`run-ci.sh`)

Se creó un script en Bash para estandarizar la ejecución del pipeline local.

* **Ubicación:** Raíz del proyecto
* **Permisos:** Se otorgó ejecución con `chmod +x run-ci.sh`
* **Contenido:** El script imprime versiones de herramientas, ejecuta `mvn clean validate compile test package` y maneja errores con `set -e`

### Registro de la primera ejecución

Se ejecutó el script `./run-ci.sh` confirmando la automatización exitosa.

#### Datos obtenidos:
* **Java Activo:** OpenJDK 17.0.17 (Temurin via SDKMAN)
* **Maven:** Apache Maven 3.8.7 (Sistema operativo)
* **Integración:** Se confirmó que Maven del sistema utiliza el `JAVA_HOME` de SDKMAN

#### Resultados del Pipeline:
1. **Limpieza y Validación:** ✅ Correctas
2. **Compilación:** ✅ Exitosa (con advertencias de API deprecada conocidas)
3. **Tests:** ✅ Se ejecutaron todos los tests, incluyendo `UUIDGenerationTest` (duración ~30s)
4. **Empaquetado:** ✅ Se generó el archivo `.jar` en el directorio `target/`

#### Gestión de Errores
Se verificó que el script cuenta con la instrucción `set -e`, lo que garantiza que si un test falla en el futuro, el script se detendrá inmediatamente y no imprimirá el mensaje de éxito, simulando el comportamiento de un servidor CI (Jenkins/GitHub Actions).

#### Errores encontrados y resolución
No se encontraron errores durante la ejecución del script. Todas las fases se completaron exitosamente.

---

## Cambio mínimo en el código y re-ejecución del pipeline

### Modificación realizada
Se seleccionó una clase del núcleo del proyecto para realizar un cambio controlado y verificar la detección de cambios del pipeline.

* **Archivo modificado:** `src/main/java/io/github/jokoframework/utils/dto_mapping/BaseEntity.java`
* **Descripción del cambio:** Se agregó un método público simple `checkPipelineStatus()` que retorna un String. Este cambio modifica el código fuente, obligando a Maven a generar un nuevo binario compilado.

### Resultados de la re-ejecución

Se ejecutó nuevamente el script de automatización `./run-ci.sh`.

#### Evidencia del proceso:
1. **Detección del cambio:** Al ejecutarse la fase `clean` seguida de `compile`, Maven eliminó los binarios anteriores y recompiló los **19 archivos fuente** del proyecto. Esto asegura que el nuevo método sea parte del bytecode final.
2. **Integridad (Tests):** Se ejecutaron nuevamente los **7 tests unitarios**.
   - **Resultado:** ✅ `BUILD SUCCESS` (0 Failures).
   - **Conclusión:** El cambio introducido fue no disruptivo y no afectó la lógica de negocio existente.
3. **Generación del Artefacto:** Se creó un nuevo archivo `.jar` en el directorio `target/` con una nueva marca de tiempo, listo para ser desplegado.

---

## Reflexión DevOps

### 1. Utilidad de gestionar múltiples versiones con SDKMAN!
En un entorno DevOps real, es común trabajar con arquitecturas heterogéneas donde conviven sistemas legado (legacy) que requieren Java 8 y microservicios modernos que corren en Java 17 o 21.
**SDKMAN!** es vital porque:
* **Consistencia:** Permite cambiar el entorno de compilación en segundos para igualar el entorno de producción, evitando el clásico error "funciona en mi máquina".
* **Agilidad:** Elimina la necesidad de reinstalar o manipular manualmente variables de entorno complejas (`PATH`, `JAVA_HOME`) cada vez que se cambia de proyecto contextualmente.

### 2. Maven desde repositorio de Ubuntu vs. Otras formas
**Ventajas del repositorio oficial (`apt`):**
* **Estabilidad y Seguridad:** Los paquetes son firmados y probados por el equipo de Ubuntu/Debian.
* **Integración:** Se actualiza junto con el resto del sistema operativo (`apt upgrade`) y es fácil de automatizar en scripts de aprovisionamiento de servidores (Ansible/Terraform).

**Desventajas:**
* **Versiones desactualizadas:** Los repositorios oficiales suelen tener versiones antiguas (ej. Maven 3.6 o 3.8 cuando ya existe la 4.0), lo que puede limitar el uso de plugins nuevos.
* **Rigidez:** Es difícil tener múltiples versiones de Maven instaladas en paralelo, a diferencia de herramientas como SDKMAN! o descargar el binario directo.

### 3. Similitud con un pipeline real (Jenkins/GitHub Actions)
Los pasos realizados en este ejercicio replican casi exactamente un "Stage" de construcción en un servidor de CI:
1.  **Checkout:** El `git clone` inicial equivale a la fase de `checkout scm`.
2.  **Environment Setup:** La configuración de SDKMAN! equivale a la definición de `tools { jdk 'java-17' }` en Jenkins o `setup-java` en GitHub Actions.
3.  **Build Execution:** El script `run-ci.sh` actúa como el ejecutor del pipeline. El uso de `mvn clean package` es el estándar industrial.
4.  **Fail Fast:** La instrucción `set -e` en nuestro script simula el comportamiento de CI: si una fase falla, todo el proceso se detiene inmediatamente y se notifica error (rojo).

### 4. Detección de fallos antes de producción
El pipeline diseñado actúa como un filtro de calidad en dos etapas críticas:
1.  **Fase `compile`:** Detecta errores de sintaxis, tipos de datos incorrectos o dependencias faltantes. Si esto falla, el código ni siquiera es ejecutable.
2.  **Fase `test`:** Es la barrera más importante. Aquí se detectan errores de lógica de negocio o regresiones (cosas que funcionaban y dejaron de hacerlo).
**Conclusión:** Si cualquiera de estas dos fases falla, el ciclo de Maven se detiene antes de llegar a la fase `package`. Esto garantiza que **nunca se genere un artefacto (JAR) defectuoso**, protegiendo así el entorno productivo de despliegues rotos.



# Ejercicio práctico - DevOps-002
# Infraestructura de CI con Docker y Jenkins

---


## Instalación y configuración de Docker Engine

### 1. Instalación desde Repositorio Oficial
Se siguió la documentación oficial de Docker para Ubuntu, configurando el repositorio `stable` y las llaves GPG para asegurar la autenticidad de los paquetes.

**Comandos utilizados:**
```bash
# 1. Configuración del llavero (Keyrings) y dependencias
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL [https://download.docker.com/linux/ubuntu/gpg](https://download.docker.com/linux/ubuntu/gpg) -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2. Agregado del repositorio oficial a apt sources
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: [https://download.docker.com/linux/ubuntu](https://download.docker.com/linux/ubuntu)
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# 3. Instalación de los paquetes del motor
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

# 2. Gestión de usuarios (Post-instalación)

Para cumplir con el requisito de no utilizar `sudo` en cada comando, se agregó el usuario actual al grupo `docker`.

**Comandos de permisos:**
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Refrescar la sesión del grupo (evita tener que reiniciar el equipo)
newgrp docker
```

---

### 3. Resolución de Problemas (Troubleshooting)

Durante la verificación, se encontró un error al intentar conectar con el demonio de Docker sin `sudo`.

**Error encontrado:**
```
Cannot connect to the Docker daemon at unix:///home/sysadmin/.docker/desktop/docker.sock
```

**Diagnóstico:** El comando `docker context ls` mostró que el contexto activo era `desktop-linux`, apuntando a una instalación de Docker Desktop en lugar del Engine nativo recién instalado.

**Solución:** Se cambió el contexto al socket por defecto de Linux.

```bash
docker context use default
```

---

### 4. Verificación de la instalación

#### Prueba funcional (hello-world)
Se ejecutó exitosamente el contenedor de prueba sin privilegios de root.

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

#### Versión instalada
Salida del comando `docker version`:

```
Docker version 29.1.3, build f52814d
```

---

## Despliegue de Jenkins en Docker


### 1. Selección de Imagen
Se seleccionó la imagen oficial de Jenkins disponible en Docker Hub bajo el tag `lts` (`jenkins/jenkins:lts`), asegurando una versión con soporte extendido y mayor estabilidad para el entorno de CI.

### 2. Comando de Despliegue y Explicación
Se diseñó y ejecutó el siguiente comando para levantar la instancia con persistencia de datos:

```bash
docker run -d \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins-server \
  jenkins/jenkins:lts
```

#### Análisis de Flags:

-d: Inicia el contenedor en modo "detached" (segundo plano).

-p 8080:8080: Publica el puerto de la interfaz web hacia el host.

-p 50000:50000: Habilita la comunicación para agentes o nodos de Jenkins.

-v jenkins_home:/var/jenkins_home: Crea y monta un Volumen de Docker. Esto garantiza la persistencia, permitiendo que la configuración y los Jobs sobrevivan incluso si el contenedor es eliminado y recreado.

--name: Asigna un identificador amigable al contenedor para facilitar su gestión.


#### Evidencia de que el contenedor está corriendo (docker ps).

Se confirmó que el contenedor se encuentra operativo mediante el comando ```docker ps```.

Evidencia de Logs (Contraseña Inicial): Se accedió a los logs del contenedor mediante docker logs jenkins-server para recuperar el token de seguridad inicial requerido para la configuración del administrador.

### Estado de Contenedores Docker

```bash
docker ps

CONTAINER ID: c803f00ad138
IMAGE:        jenkins/jenkins:lts
NAMES:        mi-jenkins
STATUS:       Up About an hour
PORTS:        0.0.0.0:8080->8080/tcp
              0.0.0.0:50000->50000/tcp
COMMAND:      "/usr/bin/tini -- /u…"
CREATED:      About an hour ago
```

## Configuración de Herramientas (Global Tool Configuration)

### 💡 Reflexión: Aislamiento del Entorno
**¿Por qué Jenkins no puede usar el Java/Maven de mi Ubuntu?**
El contenedor de Jenkins es un sistema aislado que no tiene acceso a los binarios del host (`/usr/bin/java` de Ubuntu). Por ello, debemos configurar instaladores automáticos dentro de Jenkins para que él descargue sus propias versiones en `/var/jenkins_home/tools`.

**Nota sobre Seguridad:**
Jenkins muestra una advertencia: *"Building on the built-in node can be a security issue"*. Esto indica que en producción se deberían usar agentes distribuidos. Sin embargo, para este laboratorio local, ejecutaremos los jobs en el nodo integrado (built-in) aceptando este riesgo controlado.


## Creación del Job "joko-utils-build"

Se configuró una tarea de estilo libre para compilar el proyecto utilizando las herramientas contenerizadas.

### Configuración del Job
* **Repositorio:** Fork personal de GitHub.
* **Rama:** `*/develop` (Ajustado tras detectar que el proyecto usa GitFlow).
* **JDK:** `jdk-17` (Configurado manualmente en Global Tools tras corrección).
* **Maven Goals:** `clean package`.

### Resolución de Dificultades (Troubleshooting)
Durante la configuración inicial se resolvieron dos bloqueos:
1.  **Git:** Jenkins no encontraba la rama `master`. Se corrigió apuntando a la rama existente `develop`.
2.  **JDK:** El menú de selección de JDK no aparecía. Se solucionó configurando correctamente el jdk 17 y recargando la configuración de la tarea.

---

## Ejecución y Verificación

### 1. Ejecución
Se lanzó la tarea manualmente mediante el botón **"Construir ahora"**.
* **Ejecución exitosa:** Build #3.
* **Resultado:** `SUCCESS`.

### 2. Análisis de Consola
Se verificó en la "Salida de consola" que Maven ejecutó correctamente las fases de `clean`, `compile` (descargando dependencias), `test` y `package` sin errores.

### 3. Localización del Artefacto
Se verificó la generación del binario a través de la interfaz web de Jenkins:
* **Ruta de navegación:** Menú de la tarea > **Espacio de trabajo (Workspace)** > carpeta `target`.
* **Artefacto encontrado:** `joko-utils-0.6.9.jar`.
* **Conclusión:** El entorno de CI contenerizado ha sido capaz de clonar, compilar y empaquetar el proyecto de forma autónoma, cumpliendo el objetivo del ejercicio.