from pyspark.sql import SparkSession
from pyspark.sql.dataframe import DataFrame
from pyspark.sql.functions import col, sum, avg, max, count
import sys

def main():
    spark: SparkSession = SparkSession\
        .builder\
        .appName("Ejercicio 2 - Join Simple")\
        .getOrCreate()

    # Reducimos la verbosidad
    spark.sparkContext.setLogLevel("FATAL")

    # Leo los ficheros Parquet del ejercicio 1
    dfInteracciones: DataFrame = (spark.read.format("parquet")
                   .option("mode", "FAILFAST")
                   .load("dfInteracciones.parquet"))
                   
    dfProductos: DataFrame = (spark.read.format("parquet")
                   .option("mode", "FAILFAST")
                   .load("dfInfoProductos.parquet"))

    # --- CÓDIGO DEL PROGRAMA A RELLENAR ---
    
    # 1. Join de ambos DataFrames
    


    # 2. Agrupaciones y cálculos por Marca
 


    # 3. Ordenación
   


    # Mostramos 10 filas de ejemplo
    


    
    # Lo guardamos como un único fichero CSV
    (dfResultado.coalesce(1)
           .write.format("csv")
           .mode("overwrite")
           .option("header", True)
           .save("resultados_ej2_csv"))

    
    spark.stop()

if __name__ == "__main__":
    main()