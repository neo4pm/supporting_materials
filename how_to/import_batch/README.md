# Introduction
There are different ways to import data into neo4j. The most effective and efficient one is batch import. In this section, we introduce how you can use neo4pm to convert your logfile into a format that can be used to be imported in neo4j using batch import.

## Requirement
Please make sure that you [have installed neo4pm package](../installing_neo4pm/README.md) before going throgh the rest of this text. Also, you need to setup your docker which can read from volume in your computer before following the rest of steps.


# How to import
To import your log file into neo4j using batch import, you need to i) convert the log into nodes and relations using neo4pm, and ii) load them using batch importer.

## Converting logs

Here is the python code that can be used to convert a [sample log file](./BPI2016_Clicks_NOT_Logged_In_sample1000.csv) into importable files. The result is includes:
 
 * Four files for nodes, i.e. nodes_attribute.csv, nodes_event.csv, nodes_log.csv, nodes_trace.csv.
 * One file for relation.csv

```python
import pandas as pd

from neo4pm.importer.batch import transformer as trans
from neo4pm.common import identifiers as ids

file_name = './BPI2016_Clicks_NOT_Logged_In_sample1000.csv'
log_name = 'BPIC2016Sample1000'
columns_tags = {
    ids.case_identifier      : 'SessionID',
    ids.activity_identifier  : 'PAGE_NAME',
    ids.timestamp_identifier : 'TIMESTAMP'
}

df = pd.read_csv(file_name, sep=';', encoding='latin-1', usecols=[columns_tags[c] for c in columns_tags])

result = trans.transform_log(log_name, df, columns_tags)

for r in result:
    result[r].to_csv(r+'.csv', encoding='latin-1', index=False)

```

## Loading converted logs into neo4j using batch import

To import the result into neo4j using batch import, you can follow these steps:

 * copy these five files into a directory inside a Volume folder, named import.
 * make an exmpty directory inside the Volume folder, named data.
 * execute these codes (tested in powershell in windows):
```
cd '[Write the Volume directory in which your data and import folders for neo4j are created]'

$root_dir = pwd

docker run --name analysis -v $root_dir/data:/data -v $root_dir/import:/import -d neo4j:latest

docker exec analysis neo4j-admin import --nodes=/import/nodes_log.csv --nodes=/import/nodes_trace.csv --nodes=/import/nodes_event.csv --nodes=/import/nodes_attribute.csv --relationships=/import/relation.csv  --delimiter=","


docker rm -f analysis
```
These steps are for importing data into a neo4j volume using a neo4j container.

## Running neo4j

To run the neo4j, you can run this command:
```
docker run --name analysis -e NEO4J_AUTH=neo4j/1234 --publish=7474:7474 --publish=7687:7687 -v $root_dir/data:/data  neo4j:latest 
```