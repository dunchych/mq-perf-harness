cd cphtestp
cd ssl
cp ../../secureqm/clientkey.kdb key.kdb
cp ../../secureqm/clientkey.rdb key.rdb
cp ../../secureqm/clientkey.sth key.sth
chmod 755 *.*
cd ..
wget https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev923_ubuntu_x86-64.tar.gz
tar -zxf mqadv_dev923_ubuntu_x86-64.tar.gz
rm mqadv_dev923_ubuntu_x86-64.tar.gz
cp -R MQServer/lap .
cp MQServer/mqlicense.sh .
cp MQServer/ibmmq-client_9.*_amd64.deb .
cp MQServer/ibmmq-gskit_9.*_amd64.deb .
cp MQServer/ibmmq-runtime_9.*_amd64.deb .
rm -rf MQServer
docker build --tag cphtestp .