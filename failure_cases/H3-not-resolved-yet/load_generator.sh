#kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://php-apache; done"
#kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 1; do wget -q -O- http://php-apache; done"
kubectl run -i --tty load-generator --rm --image=busybox:1.48 --restart=Never -- /bin/sh
