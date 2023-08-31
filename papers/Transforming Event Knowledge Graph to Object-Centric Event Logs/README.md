## Introduction
This folder contains all the instructions for repeating the evaluation sections of the paper "ransforming Event Knowledge Graph to Object-Centric Event Log: A Comparative Study for Multi-dimensional Process Analysis". 

## Step 1. Getting the datasets
In this paper, we used five real-world EKG data sets about BPICs challenges. Data is available online as dump files. In the links below, you can download each of the BPICs. In each link, at the bottom of the page, you need to download the files with the extension of **.dump**.

**1.** **[BPIC2014](https://data.4tu.nl/datasets/966dbc54-ea52-4c08-aac3-ffa6c2c558cd/1)** Dataset for BPIC14 challenge reprsented in EKG.

**2.** **[BPIC2015](https://data.4tu.nl/datasets/64fce6ea-5ca8-403b-aa09-82b53517af8a/1)** Dataset for BPIC15 challenge reprsented in EKG.

**3.** **[BPIC2016](https://data.4tu.nl/datasets/735e7138-7ffe-4a6a-b02d-d22bd047dc12/1)** Dataset for BPIC16 challenge reprsented in EKG.

**4.** **[BPIC2017](https://data.4tu.nl/datasets/5c9717a0-4c22-4b78-a3ad-d2234208bfd7/1)** Dataset for BPIC17 challenge reprsented in EKG.

**5.** **[BPIC2019](https://data.4tu.nl/datasets/dc66ef2b-cd5e-436f-a3fb-ebaf9ece54a3/1)** Dataset for BPIC19 challenge reprsented in EKG.

## Step 2. Import data into Neo4j

Once you have downloaded a dump file, you need to import it into Neo4j, **following the instructions mentioned** in the **repositories** of the BPICs Event Knowledge Graph. As instructed in the repositories, all dump files were created with **Neo4j v3.5**.


## Step 3. Batch export from Neo4j
Once you loaded a dump file into **Neo4j v3.5**, you need to export the graph as a batch file. To do so, Neo4j **[APOC](https://neo4j.com/labs/apoc/4.1/export/csv/)** provides support for exporting the whole graph as a CSV file. Since there are different versions of APOC, you need to download the version **compatible** with Neo4j v3.5. To do this, you need to take the following steps:

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
CALL apoc.export.csv.all("runningExample.csv", {})
```

**4.** Once you have exported all the data from the database, rename each file according to the following rule and copy it to the **data** directory:
* For BPIC14, rename the file to **bpic14.csv**.
* For BPIC15, rename the file to **bpic15.csv**.
* For BPIC16, rename the file to **bpic16.csv**.
* For BPIC17, rename the file to **bpic17.csv**.
* For BPIC19, rename the file to **bpic19.csv**.


## Step 4. Transformation
 The transformation tool is developed and tested in **[Python 3.7](https://www.python.org/downloads/release/python-370/)**. To use this tool, you need to take the following steps:
 
**1.** Make sure you have installed Python on your computer.

**2.** **install all the packages**, which is available in **requirements.txt**. You can install all the packages using the following command:
```bash
pip install -r requirements.txt
``` 
 **3.** Once you installed all the packages, lunch the **jupyter lab** using the following command:
 ```bash
 jupyter lab
 ```

 **4.** Create a new notebook and execute the following lines to transform the log. 
 
 ```Python
 from neo4pm.transformer.batch.ocel.lpg2ocel import *
 
 # this line gets the neo4j's exported csv and the destination where it shall write the transformed ocel file. 
 mdpm.lpg2ocel('../../sample_data/lpg2ocel2023/data/runningExample.csv', '../../sample_data/lpg2ocel2023/export', export_format='jsonocel')
 ```

Once the script is executed, the transformed file will be written to the export folder. The runningExample.csv file is provided in the data folder. 

We also provided the results of transformation datasets publicly available. You can find the link for downloading datasets [here](./datasets/README.md).

result of transforming the BPI Challenge 2014 event log from Event Graph format to Object-Centric Event Log (OCEL) format. 

## Step 5. Evaluation

Once you have finished transforming EKG to a set of OCELs, you can use the codes available for the evaluation. For the evaluation, we provided three Python scripts, namely: **evaluate_neo4j.ipynb**, **evaluate_ocel.ipynb**, **investigateBPIC15.ipynb**. To run each of the Python scripts, you need to follow these steps:


### Information preserving and performance checking

**1.** Ensure that Neo4j is running and you are connected to the database.

**2.** If you want to run **evaluate_neo4j.ipynb**, in the first cell, set the **experiment_name** correctly. For example, the following code sets the experiment name to **runningExample**, indicating the execution of the code will capture the runningExample scenario:
 
 ```Python
experiment_name = 'runningExample'
 ```

For example, If you want to conduct the evaluation on bpic14, set the name to **bpic14**. 



**3.** Once you run the **evaluate_neo4j.ipynb**, the result is written in **result.csv**.

**4.** For running **evaluate_ocel.ipynb**, in addition to giving a name for the experiment, you need to indicate which ocel file in the export directory shall be used. For example: 

 ```Python
experiment_name = 'runningExample'
file_path = '../../sample_data/lpg2ocel2023/export/runningExample_runningExample.jsonocel'
 ```

To calculate the loading time for Neo4j for each BPIC, we measured it using the script named evaluate_neo4j_loading_time.ps1. This script shall be run in windows powershell. 

### Evaluation result
If you execute the above scripts for all BPICs, the result will be written in **result.csv**, which can be used to generate the evaluation table presented in the paper. We also kept a copy of our experiments named **experiment-result.csv** in the **experimental_results** directory. If you are just interested in the evaluation result and do not like to run all the scripts, you can just look at this file.

Note: We have ran the evaluation once without creating any index on event timestamp and once with definition of such an index. To reproduce this result, you can do the same. To create an index, you can run this cypher command in neo4j:

 ```sql
CREATE INDEX ON :Event(timestamp)
 ```

### Demonstrating some similarities and differences

**1.** **investigateBPIC15.ipynb** include the code that generates Fig. 3 in the paper. 