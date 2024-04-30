from shot_data_reader import *
from unityLink import *
from image_processing import *
from ball_detection import *
from project_constants import *
from averaging import *
import plotly.graph_objects as go

if __name__ == "__main__":
    shot_type = "volley"
    shot_num = 1

    # Load base court images from filesystem
    base_l = cv2.imread("base_l.png", cv2.IMREAD_GRAYSCALE)
    base_r = cv2.imread("base_r.png", cv2.IMREAD_GRAYSCALE)

    # temp data storage
    calculated = pd.DataFrame(columns=["X", "Y", "Z"])
    actual = pd.DataFrame(columns=["X", "Y", "Z"])

    # Optional Plotting Object to Display
    # (see unit_tests.plot_test to see how to use this lib)
    # fig = go.Figure()
    # fig.update_layout(
    #     title = f"{shot_type} {shot_num}"
    # )


    """
    Processing per Serve
    """
    # Reading dat files
    shots = get_shot_data(shot_type=shot_type, shot_num=shot_num, fps=10)

    with NumpySocket() as client:
        client.connect(("localhost", 55001))

        ball_detected = 0
        for idx,row in shots.iterrows():
            # frames to grayscale
            gray_l, gray_r = get_frame(client, row)

            # incoming frame XOR base court
            binary_l = get_binary(base_l, gray_l)
            binary_r = get_binary(base_r, gray_r)

            circle_l = detect_circle(binary_l)
            circle_r = detect_circle(binary_r)

            # Check if ball is in frame
            if len(circle_l) > 1 and len(circle_r) > 1:
                ball_detected = 1

                # Unfiltered detected X, Y, Z
                X, Y, Z = pixel_to_coords(circle_l, circle_r)
                Z = CAMERA_HEIGHT + 2 - Z/10e5
                print(X, Y, Z)

                # Append to DataFrame
                calc_coords = pd.DataFrame({'X': X, 'Y': Y, 'Z': Z}, index=[idx])
                calculated = pd.concat([calculated, calc_coords])

                # Append equivalent real coords
                actual_coords = pd.DataFrame({'X': row.X, 'Y': row.Y, 'Z': row.Z}, index=[idx])
                actual = pd.concat([actual, actual_coords])
            else:
                # Exits loop if ball goes out of frame
                if ball_detected:
                    break

    # Quick Coordinate Reference:
    #   - X_real = X_data = Y_calc - 1
    #   - Y_real = Z_data = -X_calc
    #   - Z_real = Y_data = 22 - Z_calc/10e5 (why this is idk, must be some weird unit conversions)
    detected = pd.DataFrame()
    detected["X"] = calculated["Y"] - 1
    detected["Y"] = -calculated["X"]
    detected["Z"] = calculated["Z"] #this one is preprocessed in loop above

    given = pd.DataFrame()
    given["X"] = actual["X"]
    given["Y"] = actual["Z"]
    given["Z"] = actual["Y"]

    # Filter
    avg = running_average(detected["Z"].values, WINDOW_SIZE)
    # Finds a best fit for the trajectory of the ball before it bounces
    # returns extrapolated frame where the ball hits the ground
    impact_frame = best_fit_quadratic(avg)

    # Finds X, Y coordinates when ball hits the ground
    impact_X, impact_Y = find_xy_coords(detected['X'].values, detected['Y'].values, impact_frame)

    # COURT LIMIT DETECTION ALGO HERE, WITH impact_X, impact_Y as inputs
    # It can also use the first items of detected X and Y to determine type of serve

    #GUI LIVES HERE, CALLS OTHER FUNCTIONS AND STUFF TO DISPLAY