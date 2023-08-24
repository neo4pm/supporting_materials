## Introduction
neo4pm enables transforming Multi-Dimensional Event Knowledge Graphs (EKG) to OCEL. To do so, you need to export the EKG as a csv file and do the trsnformation as described below.


## Step 1. Batch export from Neo4j
You need to export the graph as a batch file. To do so, Neo4j **[APOC](https://neo4j.com/labs/apoc/4.1/export/csv/)** provides support for exporting the whole graph as a CSV file. Since there are different versions of APOC, you need to download the version **compatible** with Neo4j v3.5. To do this, you need to take the following steps:

**1.** Make sure you have downloaded **[apoc-3.5.0.15-all.jar](https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/tag/3.5.0.15)**, which is compatible with Neo4j v3.5.

**2.** Modify the **neo4j.conf** as instructed **[here](https://neo4j.com/docs/operations-manual/current/configuration/configuration-settings/)**. The details are explained by Neo4j, but as a summary, you can copy the following commands into the **neo4j.conf** file:
```
apoc.export.file.enabled=true
apoc.import.file.use_neo4j_config=true
apoc.import.file.enabled=true
dbms.security.procedures.unrestricted=apoc.*
dbms.security.procedures.whitelist=apoc.*
dbms.default_listen_address=0.0.0.0
```

**3.** Once everything is set, you can batch export the database by calling the following procedure:

```bash
CALL apoc.export.csv.all("exportedEKG.csv", {})
```


## Step 2. Transformation
 
 The following code helps you to transform the exported EKG to OCEL. 
 
 ```Python
 from neo4pm.transformer.batch.ocel.lpg2ocel import *
 
 # this line gets the neo4j's exported csv and the destination where it shall write the transformed ocel file. The export format can be set to xmlocel as well.
 mdpm.lpg2ocel('source_path/exportedEKG.csv', 'destination_path', export_format='jsonocel')
 ```

Once the script is executed, the transformed file will be written to the export folder.
