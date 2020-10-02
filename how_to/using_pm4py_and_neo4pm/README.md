# Introduction
This section describes how you can get the dfg and visualize the result using PM4Py.

## requriements

* You should have fulfilled the requriement to query dfg from neo4j as described [here](../query_dfg/README.md).


## Visualize result
It is quite straight forward to combine neo4pm and PM4Py. You can run these codes to do so:

```python
from neo4pm import log_manager

# getting dfg from Graph Database
lm = log_manager('bolt://localhost:7687', 'neo4j', '1234')
dfg = lm.get_dfg('BPIC2016Sample1000')

# visulizing DFG using PM4Py
from pm4py.visualization.dfg import factory as dfg_vis_factory

gviz = dfg_vis_factory.apply(dfg)
dfg_vis_factory.view(gviz)
```