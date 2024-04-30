import numpy as np
from scipy import optimize
import matplotlib.pyplot as plt
from project_constants import *

def running_average(data, window_size):
    averages = []
    for i in range(len(data) - window_size + 1):
        window = data[i:i+window_size]
        average = sum(window) / window_size
        averages.append(average)
    return averages

def best_fit_quadratic(arr):
    def quadratic(x, a, b, c):
        return a*x**2 + b*x + c
    def solve_quadratic_positive(a, b, c):
        discriminant = b**2 - 4*a*c
        root1 = (-b + np.sqrt(discriminant)) / (2*a)
        root2 = (-b - np.sqrt(discriminant)) / (2*a)
        return max(root1, root2)
    def get_r2(x, y, p):
        residuals = y-quadratic(x, *p)
        ss_res = np.sum(residuals**2)
        ss_tot = np.sum((y-np.mean(y))**2)
        r_squared = 1 - (ss_res / ss_tot)
        return r_squared

    mid = int(len(arr)/2)
    end = len(arr)

    best_fit_frame = 0
    best_r_square = 0

    for i in range(mid, end):
        y = arr[:i]
        x = np.array(range(1, len(y)+1))

        p , e = optimize.curve_fit(quadratic, xdata=x, ydata=y)

        if e is None:
            continue
        else:
            r_square = get_r2(x, y, p)
            if r_square > best_r_square:
                best_r_square = r_square
                best_fit_frame = solve_quadratic_positive(*p) + WINDOW_SIZE
    print(f"Ball touches the ground at frame {best_fit_frame}")
    return best_fit_frame

def find_xy_coords(x_arr, y_arr, frame):
    def linear(x, a, b):
        return a*x + b
    def solve_for_var(y, a, b):
        return (y-b)/a

    xdata = np.array(range(1, round(frame-2)+1))
    x_arr = x_arr[:round(frame-2)]
    y_arr = y_arr[:round(frame-2)]

    x_p, x_e = optimize.curve_fit(linear, xdata=xdata, ydata=x_arr)
    y_p, y_e = optimize.curve_fit(linear, xdata=xdata, ydata=y_arr)

    X = linear(frame, *x_p)
    Y = linear(frame, *y_p)
    print(f"At impact, the ball coordinates are X:{X}, Y:{Y}")
    return X, Y

