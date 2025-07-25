@echo off
echo Stopping Private Web3 Development SDK...

docker-compose -f windows-compose.yaml down

echo.
echo SDK stopped successfully.
echo Data is preserved in C:\web3-sdk-data
echo.

pause