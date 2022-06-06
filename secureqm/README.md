Build and deploy NativeHA MQ instance
https://www.ibm.com/docs/en/ibm-mq/9.2?topic=manager-example-configuring-tls

```
oc apply -f secureqm-cm.yaml
oc apply -f secureqm-secret.yaml
oc apply -f secureqm-qm.yaml
oc apply -f secureqm-lb.yaml
```

Test 
Update /Users/yaro/projects/mq-perf-harness/secureqm/CCDT.json with correct LB endpoint
```
oc get svc |grep LoadBalancer

export MQCCDTURL=/Users/yaro/projects/mq-perf-harness/secureqm/CCDT.json 
export MQSSLKEYR=/Users/yaro/projects/mq-perf-harness/secureqm/clientkey 

/opt/mqm/samp/bin/amqsputc TEST SECUREQM
```

