 # Materiales de la asignatura Procesamiento Paralelo de Datos (UPCT - UMU)

# Uso de WSL para usuarios con Windows.

Asumimos que has descargado e instalado Visual Code Studio (VSCode)

Abre una terminal PowerShell e instala Ubuntu como subsistema Linux.
Si no lo has instalado nunca es posible que tengas que reiniciar el sistema después de ejecutar la orden

```bash
wsl --install Ubuntu
```

Lanza VSCode e instala la extensión "Remote Development" de Microsoft desde la store de extensiones dentro de VSCode
O el específico para WSL https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl
Instala también si no las tienes las extensiones Python de Microsoft y Jupiter
Cierra VSCode

Arranca WSL con

```bash
wsl
```

O con el siguiente si tienes varias distribuciones

```bash
wsl --distribution Ubuntu
```

Clona el repositorio dentro de tu instalación de Ubuntu

```bash
git clone https://github.com/ProcParDatos/ppd-public.git
```

Ve al path donde esté el clone del proyecto y lanza VSCode

```bash
cd ppd-public
code .
```

Para cada práctica existe un entorno de desarrollo y unas instrucciones específicas (README.md)  
Por ejemplo la Practica 1 estaría en environment/p1/README.md  
Sigue las instrucciones README de cada práctica concreta en su carpeta environment  
Si no te detecta UV después de instalarlo, cierra la terminal y vuelve a abrirla  


El proyecto se abrirá desde WSL

![Ejemplo WSL](https://microsoft.github.io/vscode-remote-release/images/remote-wsl-open-code.gif)


# Ejemplo de practica 1

VSCode -> Terminal -> Nueva Terminal
```bash
cd environment/p1
curl -LsSf https://astral.sh/uv/install.sh | sh
```
Cierra terminal
VSCode -> Terminal -> New Terminal
```bash
cd environment/p1
uv python install
uv lock
uv sync --locked
```

Ahora te recomendamos que para que VSCode encuentre el entorno que has creado abras la carpeta environment/p1 (File -> Open Folder).  
Selecciona ppd-public/environment/p1  
Arrastra los jupiter notebooks que has descargado del Aula Virtual a la carpeta environment/p1 en navegador (Explorer) de VSCode  
Ahora ya puedes abrir el notebook que corresponda y ejecutar en local seleccionando el entorno (Ctrl+Shift+P -> Python: Select Interpreter -> Python 3.12.3(p1) .venv/bin/python)  


