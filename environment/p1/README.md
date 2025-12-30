# Instrucciones para crear un entorno de trabajo
# para la Práctica 1 de Procesamiento Paralelo de Datos
# en macOS / Linux nativo / WSL2 (Ubuntu) - Dentro de WSL

# Instala uv

curl -LsSf https://astral.sh/uv/install.sh | sh

# Instala python y las dependencias #

uv python install
uv lock
uv sync --locked

# Arranca VSCode y abre la carpeta environment/p1 #

# Pulsa Ctrl+Shift+P / Cmd+Shift+P
# Ejecuta: Python: Select Interpreter
# Elige el Python de tu venv:
# Linux / macOS / WSL: p1/.venv/bin/python

# Para limpiar los Notebooks usa Ctrl+Shift+P, luego selecciona "Notebook: Clear All Outputs"
