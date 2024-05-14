import time
import numpy as np

if __name__ == "__main__":
    m = 16
    mat_a = np.random.random((m, m))
    mat_b = np.random.random((m, m))
    program_start_ts = time.time()
    last_ts = 0
    end_to_end_runtime_in_sec = 120
    inner_loop_in_sec = 1
    while time.time() - program_start_ts < end_to_end_runtime_in_sec:
        inner_ts = time.time()
        while time.time() - inner_ts < inner_loop_in_sec:
            temp = np.matmul(mat_a, mat_b)
        time.sleep(inner_loop_in_sec)
    f = open("fifty-cpu-util-app.txt", "w")
    f.write("done")
    f.close()
