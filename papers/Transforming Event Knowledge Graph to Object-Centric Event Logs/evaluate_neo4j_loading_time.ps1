$root_dir = pwd
Write-Output $root_dir

rm ./data/* -r


$start = (Get-Date)
docker run --name bpic --env=NEO4J_dbms_active__database=test --publish=7474:7474 --publish=7687:7687 -v $root_dir/data:/data -v $root_dir/import:/import -d neo4j:3.5

$res = docker inspect -f "{{.State.Running}}" bpic
Start-Sleep -Seconds 3
docker exec bpic neo4j-admin load --database=graph.db --from=/import/neo4j-bpic19-2021-02-17.dump 
docker rm -f bpic
docker run --name bpic --env NEO4J_AUTH=neo4j/1234  --publish=7474:7474 --publish=7687:7687 -v $root_dir/data:/data -d neo4j:3.5

do {
  $statusCode = wget http://localhost:7474/browser/ | % {$_.StatusCode}
  Start-Sleep -Seconds 0.5
}
while ($statusCode -ne 200)

$end = (Get-Date)

Write-Output "This script started at $start"
Write-Output "This script ended at $end"
Write-Output "This script took $($end-$start) to run"

#bpic14 00:00:53.5866440
#bpic15 00:00:25.9665998
#bpic16 00:02:46.0248871
#bpic17 00:00:45.0310398
#bpic19 00:01:02.4783868