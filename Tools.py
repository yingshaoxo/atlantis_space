# Run this to generate bash auto complete script: Tools -- --completion

import os, re
from auto_everything.python import Python
from auto_everything.terminal import Terminal
from auto_everything.disk import Disk
from auto_everything.develop import YRPC
from auto_everything.io import IO

from pprint import pprint

py = Python()
t = Terminal(debug=True)
disk = Disk()
yrpc = YRPC()
io_ = IO()

def itIsWindows():
    if os.name == 'nt':
        return True
    return False

class Tools():
    def __init__(self) -> None:
        self.project_root_folder = disk.get_directory_path(os.path.realpath(os.path.abspath(__file__))) 
        self.protobuff_protocols_folder = disk.join_paths("lib/protocols")

    def build_protocols(self):
        the_generated_grpc_folder = disk.join_paths(self.project_root_folder, "lib/generated_grpc")

        yrpc.generate_code(
            which_language="dart",
            input_folder=self.protobuff_protocols_folder, 
            input_files=["models.proto"],
            output_folder=the_generated_grpc_folder,
        )


py.fire(Tools)