# Note that it is not being used in kubectl_command.sh
# In kubectl_command.sh raw command line is used


kubectl autoscale deployment nginx-deployment --cpu-percent=50 --min=3 --max=5
