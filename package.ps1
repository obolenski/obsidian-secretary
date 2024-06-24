$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent

$baseDir = "./lambda/layers"
$depsLayerDir = "deps"
$pythonDepsLayerZip = "python-deps-layer.zip"

cd "$baseDir/$depsLayerDir"
docker build -t python-deps-layer .
$pythonContainerId = docker create python-deps-layer
docker cp "$pythonContainerId`:/var/task/python" ./
docker rm $pythonContainerId
Compress-Archive -Path "python" -DestinationPath "../../$pythonDepsLayerZip" -Force
Remove-Item -Path "python" -Recurse -Force

cd $scriptDir

Compress-Archive -Path "./lambda/main/*" -DestinationPath "./lambda/lambda.zip" -Force
