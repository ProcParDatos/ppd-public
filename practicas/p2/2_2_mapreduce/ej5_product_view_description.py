from mrjob.job import MRJob
from mrjob.step import MRStep

TOP_N = 10

class MRTopViewedProducts(MRJob):

    """
    Mapper:
    - Lee cada línea del txt
    - Ignora líneas corruptas o cabecera
    - Extrae event_type, product_id, category_code, brand
    - Si event_type == "view", emite (product_id, (1, category_code, brand))
    """
   

    def reducer_count(self, product_id, values):
        """
        Reducer:
        - Suma el total de views para cada product_id y obtiene category_code y brand
        - Necesita iterar sobre todos los valores del tipo (count, category_code, brand) para sumar counts y obtener la info del producto
        - Emite (None, (total_views, product_id, category_code, brand))
        """
        
 
    def reducer_top_n(self, _, values):
        """
        Reducer:
        - Recibe (None, (total_views, product_id, category_code, brand)) para todos los productos
        - Ordena por total_views y emite los TOP_N productos más vistos
        """
       
    
    # -------------------------
    def steps(self):
        return [
            MRStep(
                mapper=self.mapper,
                reducer=self.reducer_count
            ),
            MRStep(
                reducer=self.reducer_top_n
            )
        ]


if __name__ == '__main__':
    MRTopViewedProducts.run()