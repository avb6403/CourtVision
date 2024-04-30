import numpy as np
import pandas as pd

def get_shot_data(shot_type: str = 'serve', shot_num=1, every_nth_row=10, start=0, end=0):
    path = "serves/"
    file_name = f"{shot_type}{shot_num}.dat"

    df = pd.read_csv(path + file_name, header=None, names=["X", "Y", "Z"], delimiter=' ') 

    if end != 0:
        filtered = df.iloc[start:end:every_nth_row]
    else:
        filtered = df.iloc[start::every_nth_row]

    return filtered
