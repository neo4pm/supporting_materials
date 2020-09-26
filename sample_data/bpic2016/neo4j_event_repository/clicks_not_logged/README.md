# Introduction
The files in this folder can be used to create the event repository in neo4j, which is based on the "clicks not logged" log from BPIC 2016. 

# Basic Setups
These files shall be imported to neo4j through [neo4j-admin](https://neo4j.com/docs/operations-manual/current/tools/import/). This command enables you to import large amounts of data into a Neo4j database from CSV files very fast as a batch process.

# Creating the Event Repository
To create the event repository, you can unzip all files in this directory into the import directory of neo4j. We used [7-Zip](https://www.7-zip.org/) application to compress the files using [7z](https://www.7-zip.org/7z.html) format.

The actual import can be done using this command:

```
neo4j-admin import --nodes=/import/nodes_log.csv --nodes=/import/nodes_trace.csv --nodes=/import/nodes_event.csv --nodes=/import/nodes_attribute.csv --relationships=/import/relations.csv  --delimiter=","
```

Note that you need to refine the path to the import folder based on your settings.