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
#        cur_time = time.time()
#        if  cur_time - last_ts > 1 or last_ts == 0:
#            print("time passed: ",  cur_time - last_ts)
#            f = open(str(cur_time - last_ts) + ".txt", "w")
#            f.write(str(cur_time - last_ts))
#            f.close()
#            last_ts = time.time()

    f = open("app_done.txt", "w")
    f.write("done")
    f.close()
