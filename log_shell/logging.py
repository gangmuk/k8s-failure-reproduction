import subprocess

if __name__ == "__main__":
  ret = subprocess.Popen(["./for_loop.sh"])
  ret.communicate()
  subprocess.Popen(["ls","-al"])
  
