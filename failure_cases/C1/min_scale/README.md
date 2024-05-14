# Autoscaling caused by request-unrelated reason. (e.g., App initialization, Garbage collection)

## Configuration
- Metrics-server: on, change 
- HPA: on, 50% threshold
- Descheduler: off

## Steps
1. Cook my own app. (app.py in h1 failure case)
    - App
        - Phase 1 (first 60 seconds): Run CPU intensive workload. CPU utilization should be higher than 50% to trigger autoscaler to scale up.
        - Phase 2 (after phase 1): sleep. (low cpu utilization)

2. Dockerize the app and run the app when the container is created.
    - Write Dockerfile.
    - Build image and push it to my docker hub registry.
3. Write deployment yaml using the docker images I just created above. (gangmuk/h1-app:[tag])
    - Deployment yaml file should execute the python app we wrote in step 1.
    - Use `command` field
    ```yaml
    ...
    spec:
      containers:
      - name: h1-app
        image: gangmuk/h1-app:v25
        imagePullPolicy: IfNotPresent
        command: ['bash', '-c', 'sleep 14400']
        command: ['bash', 'run.sh']
    ...
    ```
4. Apply the deployment!


### Extra
    I still don't understand why but Dockerfile's `CMD`, `ENTRYPOINT` commands didn't execute the specified command.
    None of commands below were not executed at the beginning of the container creation.
    ```dockerfile
    ...
    CMD ["/H1/run.sh"]
    ENTRYPOINT ["run.sh"]
    ENTRYPOINT ["echo" "asdf" ">" "ent.txt"]
    CMD ["echo" "qwer" ">" "cmd.txt"]
    ...
    ```
