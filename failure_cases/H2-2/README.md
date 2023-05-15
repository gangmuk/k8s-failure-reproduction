# H2 failure case

## Number of replica over time
### Scenario 1
1(nginx_1.yaml) -> 6(HPA min) -> 3(nginx_2.yaml) --hpa scan interval(15s)--> 6(HPA min)

### Scenario 2
1(nginx_1.yaml) -> 3(HPA min) -> 6(nginx_2.yaml) --scale down window(5min)--> 3(HPA min)

## Steps
1. Apply nginx_1.yaml which does not specify `replica` field.
2. Run autoscaler for nginx-deployment.
3. Apply nginx_2.yaml whose `replica` field is specified. (e.g., 6)

