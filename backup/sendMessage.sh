#!/bin/bash
# © Copyright IBM Corporation 2021
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export MQCCDTURL="${DIR}/ccdt_generated.json"
export MQSSLKEYR="${DIR}/from-scratch/clientkey"

#export PORT="$(kubectl get services secureapphelm-ibm-mq-qm -n default -o jsonpath='{.spec.ports[].nodePort}')"
export PORT=443
export IPADDRESS=secureqm-ibm-mq-web-cp4i.apps.mq-ocp48.labocp48.net
#export IPADDRESS="$(kubectl get nodes -o jsonpath='{..addresses[1].address}' | awk '{print $1}')"

( echo "cat <<EOF" ; cat ccdt_template.json ; echo EOF ) | sh > ccdt_generated.json

echo "Starting amqsphac" sequreqm
/opt/mqm/samp/bin/amqsphac EXAMPLE.QUEUE SECUREQM
