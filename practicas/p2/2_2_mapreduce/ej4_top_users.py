from mrjob.job import MRJob
from mrjob.step import MRStep

TOP_N = 10


class MRTopUsersSimple(MRJob):

    def mapper_count(self, _, line):
        """
        Mapper:
        - Lee cada línea del txt
        - Ignora líneas corruptas o cabecera
        - Extrae user_id
        - Yield (user_id, 1)
        """
        

    def reducer_count(self, user_id, values):
        """
        Reducer:
        - Suma todos los valores asociados a cada user_id y hace yield 
        (None, (count, user_id)) 
        para preparar la siguiente fase de ordenamiento
        """
       

   
    def reducer_topn(self, _, user_count_pairs):
        """
        Reducer:
        - Recibe (None, (count, user_id)) para todos los usuarios
        - Ordena por count y emite los TOP_N usuarios con más eventos
        """
       
       

    def steps(self):
        return [
            MRStep(mapper=self.mapper_count,
                   reducer=self.reducer_count),
            MRStep(reducer=self.reducer_topn)
        ]


if __name__ == '__main__':
    MRTopUsersSimple.run()