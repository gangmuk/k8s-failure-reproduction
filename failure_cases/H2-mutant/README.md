
## Steps
1. nginx_1.yaml does not specify replica field.
2. apply nginx_1.yaml
3. num replica is 1.
4. apply autoscaler with minReplica=3.
5. num replica becomes 3.
6. nginx_2.yaml has replica field: 6.
7. apply nginx_2.yaml
8. num replica becomes 6.
9. delete deploy/nginx-deployment
10. apply nginx_1.yaml which does not specify replica field.
11. num replica: 1 => 3 by HPA => 6 
    -  This is NOT something we expect. It should 1 or 3. Apparently it is none of them but 6. This is **because the number replica field in nginx_2.yaml is still remaining.** nginx_1.yaml does not have replica field and I don't know why but replica field from the last nginx_2.yaml is still there, creating 6 replica when nginx_1.yaml is applied. 
