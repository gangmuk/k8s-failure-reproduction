import time
import numpy as np

if __name__ == "__main__":
    m = 16
    mat_a = np.random.random((m, m))
    mat_b = np.random.random((m, m))
    ts = time.time()
    last_ts = 0
    while time.time() - ts < 120:
        temp = np.matmul(mat_a, mat_b)
    f = open("app_done.txt", "w")
    f.write("done")
    f.close()
