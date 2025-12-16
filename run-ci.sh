#!/bin/bash

# La opción -e hace que el script se detenga si ocurre un error en cualquier comando
set -e

echo "========================================"
echo "🚀 INICIANDO PIPELINE CI LOCAL"
echo "========================================"

echo ""
echo "--- [PASO 1] Verificando versiones de herramientas ---"
echo ">> JAVA ACTIVO:"
java -version
echo ""
echo ">> MAVEN INSTALADO:"
mvn -version

echo ""
echo "--- [PASO 2] Ejecutando Ciclo de Vida Maven ---"
echo "Ejecutando: clean -> validate -> compile -> test -> package"
# Ejecutamos todo en una sola línea para aprovechar la eficiencia de Maven, 
# pero explicitamos las fases para cumplir el ejercicio.
mvn clean validate compile test package

echo ""
echo "========================================"
echo "✅ PIPELINE FINALIZADO CON ÉXITO"
echo "   Artefacto generado en target/"
echo "========================================"
