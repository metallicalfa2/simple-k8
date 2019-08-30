docker build -t metallicalfa/multi-client:latest -t metallicalfa/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t metallicalfa/multi-server:latest -t metallicalfa/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t metallicalfa/multi-worker:latest -t metallicalfa/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push metallicalfa/multi-client:latest
docker push metallicalfa/multi-server:latest
docker push metallicalfa/multi-worker:latest

docker push metallicalfa/multi-client:$SHA
docker push metallicalfa/multi-server:$SHA
docker push metallicalfa/multi-worker:$SHA

kubectl apply -f k8s
echo "----------- kubectl apply completed --------------"
kubectl set image deployments/server-deployment server=metallicalfa/multi-server:$SHA
kubectl set image deployments/client-deployment client=metallicalfa/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=metallicalfa/multi-worker:$SHA