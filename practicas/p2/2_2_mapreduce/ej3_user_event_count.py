from mrjob.job import MRJob

class MRUserEventCount(MRJob):

    def mapper(self, _, line):
        """
        Mapper:
        - Lee cada línea del txt
        - Ignora líneas corruptas o cabecera
        - Extrae user_id
        - Yield (user_id, envent_type, 1)
        """
       

    def reducer(self, key, values):
        """
        Reducer:
        - Suma todos los valores asociados a cada user_id, event_type
        """
        


if __name__ == '__main__':
    MRUserEventCount.run()