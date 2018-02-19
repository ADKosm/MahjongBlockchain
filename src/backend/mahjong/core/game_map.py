import json


class GameMap:
    """
    map ~ [.. [z, x, y, d, type] ..]

    d = 0 -> ##

    d = 1 -> #
             #
    """
    def __init__(self, raw_map, timestamp):
        self.raw_map = raw_map
        self.timestamp = timestamp

    def pack(self):
        return json.dumps(self.raw_map), self.timestamp

    @staticmethod
    def load_from_parameters(map_parameter: str, timestamp_parameter: int):
        return GameMap(raw_map=json.loads(map_parameter), timestamp=timestamp_parameter)

    @staticmethod
    def load_from_file(filename):
        with open(filename, 'r') as file:
            return GameMap(raw_map=json.load(file), timestamp=0)
