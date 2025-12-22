@echo off
echo Stopping and removing test containers...

docker stop tictactoe argocd grafana prometheus mongodb solar-system 2>nul
docker rm tictactoe argocd grafana prometheus mongodb solar-system 2>nul

echo Cleanup complete!