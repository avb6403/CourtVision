from shot_data_reader import *
from unityLink import *
from image_processing import *
from ball_detection import *
from project_constants import *
import plotly.graph_objects as go

def unity_link_test():
    shots = get_shot_data(shot_type="serve", shot_num=1, every_nth_row=50, end=500)

    with NumpySocket() as client:

        client.connect(("localhost", 55001))

        gray_l, gray_r = get_frame(client, shots.iloc[2])

        return gray_l, gray_r

def image_processing_test():
    shots = get_shot_data(shot_type="serve", shot_num=1, every_nth_row=10, end=500)

    base_l = cv2.imread("base_l.png", cv2.IMREAD_GRAYSCALE)
    base_r = cv2.imread("base_r.png", cv2.IMREAD_GRAYSCALE)

    with NumpySocket() as client:
        client.connect(("localhost", 55001))

        for idx,row in shots.iterrows():
            gray_l, gray_r = get_frame(client, row)

            binary_l = get_binary(base_l, gray_l)
            binary_r = get_binary(base_r, gray_r)

            circle_l = detect_circle(binary_l)
            circle_r = detect_circle(binary_r)

            print(circle_l)
            print(circle_r)
            print()

    print()

    return circle_l, circle_r

def ball_detection_test():
    shots = get_shot_data(shot_type="serve", shot_num=1, every_nth_row=10, end=500)

    base_l = cv2.imread("base_l.png", cv2.IMREAD_GRAYSCALE)
    base_r = cv2.imread("base_r.png", cv2.IMREAD_GRAYSCALE)

    with NumpySocket() as client:
        client.connect(("localhost", 55001))

        for idx,row in shots.iterrows():
            gray_l, gray_r = get_frame(client, row)

            binary_l = get_binary(base_l, gray_l)
            binary_r = get_binary(base_r, gray_r)

            circle_l = detect_circle(binary_l)
            circle_r = detect_circle(binary_r)

            if len(circle_l) > 1 and len(circle_r) > 1:
                X, Y, Z = pixel_to_coords(circle_l, circle_r)
                print(X, Y, Z)
                print(row.X, row.Y, row.Z)
                print()
            else:
                print(0,0,0)
    print()

def plot_test():
    shots = get_shot_data(shot_type="volley", shot_num=4, every_nth_row=10, end=1200)

    calculated = pd.DataFrame(columns=["X", "Y", "Z"])
    actual = pd.DataFrame(columns=["X", "Y", "Z"])
    fig = go.Figure()

    base_l = cv2.imread("base_l.png", cv2.IMREAD_GRAYSCALE)
    base_r = cv2.imread("base_r.png", cv2.IMREAD_GRAYSCALE)

    with NumpySocket() as client:
        client.connect(("localhost", 55001))

        for idx,row in shots.iterrows():
            gray_l, gray_r = get_frame(client, row)

            binary_l = get_binary(base_l, gray_l)
            binary_r = get_binary(base_r, gray_r)

            circle_l = detect_circle(binary_l)
            circle_r = detect_circle(binary_r)

            if len(circle_l) > 1 and len(circle_r) > 1:
                X, Y, Z = pixel_to_coords(circle_l, circle_r)
                Z = CAMERA_HEIGHT + 2 - Z/10e5
                print(X, Y, Z)
                calc_coords = pd.DataFrame({'X': X, 'Y': Y, 'Z': Z}, index=[idx])
                calculated = pd.concat([calculated, calc_coords])

                actual_coords = pd.DataFrame({'X': row.X, 'Y': row.Y, 'Z': row.Z}, index=[idx])
                actual = pd.concat([actual, actual_coords])
            else:
                coords = pd.DataFrame({'X': 0, 'Y': 0, 'Z': 0}, index=[idx])

    # Quick Coordinate Reference:
    #   - X_real = X_data = Y_calc - 1
    #   - Y_real = Z_data = -X_calc
    #   - Z_real = Y_data = 22 - Z_calc/10e5 (why this is idk, must be some weird unit conversions)

    fig.add_trace(go.Scatter3d(x=calculated['Y']-1, y=-calculated['X'], z=calculated['Z']))
    fig.add_trace(go.Scatter3d(x=actual['X'], y=actual['Z'], z=actual['Y']))

    fig.show()
    print()


if __name__ == '__main__':
    # unity_link_test()
    # image_processing_test()
    # ball_detection_test()
    plot_test()