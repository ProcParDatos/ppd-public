from pyspark.sql import SparkSession
from pyspark.sql.dataframe import DataFrame
from pyspark.sql.functions import col, hour, count
import sys

def main():
    spark: SparkSession = SparkSession\
        .builder\
        .appName("Ejercicio 4 - Top marcas por hora")\
        .getOrCreate()

    spark.sparkContext.setLogLevel("FATAL")

    # Cargamos el fichero original
    df_ecommerce: DataFrame = (spark.read
        .option("inferSchema", "true")
        .option("header", "true")
        .csv("2019-Oct_600k.txt"))

    # --- CÓDIGO DEL PROGRAMA A RELLENAR ---
    
   # 1. Definir la lista de marcas objetivo y filtrar el DataFrame
   
   
    # 2. Extraer la Hora de la columna event_time
    # Usamos la función hour() nativa de PySpark sobre el df ya filtrado
   

    
    # 3. Agrupar por Marca y Hora, y contar las interacciones
    


    # 4. Seleccionar columnas finales, renombrar y ordenar
    # Ordenamos primero por Marca (ascendente) y luego por la Hora (ascendente)
   


    # Mostramos los primeros resultados por pantalla para verificar
    dfResultado.show(20)

    # ----------------------------------------------------

    # Lo guardamos como un único fichero CSV
    
    (dfResultado.coalesce(1)
           .write.format("csv")
           .mode("overwrite")
           .option("header", True)
           .save("resultados_ej4_csv"))
    
    
    spark.stop()

if __name__ == "__main__":
    main()