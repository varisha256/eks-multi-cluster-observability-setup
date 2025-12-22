@echo off
echo Testing images locally with Docker...
echo.

echo Starting TicTacToe...
docker run -d --name tictactoe -p 80:80 nginx:alpine

echo Starting ArgoCD...
docker run -d --name argocd -p 8080:8080 --platform linux/amd64 -e ARGOCD_SERVER_INSECURE=true quay.io/argoproj/argocd:v2.12.4

echo Starting Grafana...
docker run -d --name grafana -p 3000:3000 --platform linux/amd64 -e GF_SECURITY_ADMIN_PASSWORD=admin grafana/grafana:11.3.0

echo Starting Prometheus...
docker run -d --name prometheus -p 9090:9090 --platform linux/amd64 prom/prometheus:v2.55.1

echo Starting MongoDB...
docker run -d --name mongodb -p 27017:27017 --platform linux/amd64 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password123 -e MONGO_INITDB_DATABASE=solarsystem mongo:7.0

echo Starting Solar System...
docker run -d --name solar-system -p 3001:3000 --platform linux/amd64 --link mongodb -e MONGO_URL=mongodb://admin:password123@mongodb:27017/solarsystem?authSource=admin siddharth67/solar-system:v1

echo.
echo Waiting 30 seconds for services to start...
timeout /t 30

echo.
echo Testing endpoints...
echo TicTacToe: http://localhost
echo ArgoCD: http://localhost:8080
echo Grafana: http://localhost:3000 (admin/admin)
echo Prometheus: http://localhost:9090
echo Solar System: http://localhost:3001

echo.
echo To stop all containers:
echo docker stop tictactoe argocd grafana prometheus mongodb solar-system
echo docker rm tictactoe argocd grafana prometheus mongodb solar-system