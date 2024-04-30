from project_constants import *

def pixel_to_coords(l_coords, r_coords):
    x_l = l_coords[0]
    y_l = l_coords[1]
    x_r = r_coords[0]
    y_r = r_coords[1]

    def calculateZ():
        return (B*F)/(abs((y_l-W_CENTER)-(y_r-W_CENTER))*PS)
    def calculateX(x, Z):
        return Z *(x - W_CENTER)*PS / F
    def calculateY(y, Z):
        return Z *(y - H_CENTER)*PS / F

    Z = round(calculateZ(), 2)
    X = round(calculateX(x_l, Z)/1000, 2)
    Y = round(calculateY(y_l, Z)/1000, 2)

    return X, Y, Z

def ball_out_of_bounds():
    return 0