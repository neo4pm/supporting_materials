# Introduction
This section describes how you can get the dfg for your log that is imported into neo4j.

## requriements

* You should have imported your log to neo4j and run your neo4j as described [here](../import_batch/README.md).


## Query DFG
It is quite straight forward to query DFG using neo4pm. You can run these codes to do so:

```python
from neo4pm import log_manager
lm = log_manager('bolt://localhost:7687', 'neo4j', '1234')
dfg = lm.get_dfg('BPIC2016Sample1000')
```

We are developing more functionalities to query the logs in graph database. The graph can be queried using Cypher as well. Example:


```python
from neo4pm.connection import connection_manager as cm
connection = cm('bolt://localhost:7687', 'neo4j', '1234')
cmd = """
    match (t1:Attribute {key:'concept_name'})<--(:Event)-[n:next]->(:Event)-->(t2:Attribute {key:'concept_name'})
    return t1.val as dfg_from, t2.val as dfg_to, count(n) as dfg_freq
"""
dfg = connection.get_query_result(cmd)
dfg = {(r['dfg_from'], r['dfg_to']): r['dfg_freq'] for r in dfg}
```