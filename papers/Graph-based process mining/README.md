# Introduction
This folder contains instructions for repeating the evaluation section, which is used in the "Graph-based process mining" paper.
The paper is accepted in the 5th International Workshop on Process Querying, Manipulation, and Intelligence ([PQMI 2020](http://processquerying.com/pqmi2020/)), which is co-located with the 2nd International Conference in Process Mining ([ICPM 2020](https://icpmconference.org/2020/)). 

The link for the author-copy and published version will be available soon.

You can cite this paper by:
```
coming soon
```

# Evaluation Process
The evaluation process in this paper is shown in figure below.

![Evaluation Process Image](./images/EvaluationProcess.svg)

This process shall be followed through these steps:
  1. The process starts by "setup the environment", where you need to have installed the docker in your computer. 
  2.  The "define the experiments list" shall be done to define the number of experiments and their parameters as a list.
  3.  The "select an experiment from the list" shall be performed to select an experiments and its parameters.
  4. The "setup the environment" shall be performed to set the analysis environment for the selected experiemnt.
  5. The "run the experiment" shall be performed to measure the performance.
  6. The "remove the experiment from the list" shall be performed to remove the experiement from the list.
  7. If the experiment list is empty, the process shall be repeated from step 3.
  8. All results shall be compared by performing the "compare the result" task.

These steps are explained below.

## setup the environment
To run this process, you need to install docker on your computer. The docker needs to have access to your hard drive for mounting the volumes that store data for event repository. Note that you also need to assign enough CPUs and memory to your docker to be assigned for conatiners in the evaluation process. The CPU can be set to 5, and RAM can be set to 5 GB. 

You also need to prepare the logs for both Pm4Py and neo4j.

For PM4Py, download "clicks not logged" log from [BPIC 2016](https://www.win.tue.nl/bpi/doku.php?id=2016:challenge). We have used the CSV version of this log. Put this log file in the log sub-directory in the volume directory. The volume shall be mounted to docker.

For neo4j, you need to create the event repository. Cretae two sub-directories in the volume folder named data and import. Unzip the 7-zip files into import folder.  To do so, , you can follow [the instruction here](../../sample_data/bpic2016/neo4j_event_repository/clicks_not_logged/README.md). 

Here is the code that is used in this paper to import the data. You can adjust the variables and path and re-run it on your computer:

```
cd '[Write the Volume directory in which your data and import folders for neo4j are created]'
rm ./data/* -r
$root_dir = pwd
docker run --name analysis -v $root_dir/data:/data -v $root_dir/import:/import -d neo4j:latest
docker exec analysis neo4j-admin import --nodes=/import/nodes_log.csv --nodes=/import/nodes_trace.csv --nodes=/import/nodes_event.csv --nodes=/import/nodes_attribute.csv --relationships=/import/relations.csv  --delimiter=","
docker rm -f analysis
```


## define the experiments list
There are two experiements in the evaluation section of this study, but both of them are based on calculating DFGs based on different parameters that we assign to containers. Thus, one list can be genrated to drive the whole study.

The first experiemnt  calculate the DFGs based on the whole events in the logfile, and it consider CPU and RAM of conatienrs as variables. The CPU is assigned from range of 0.5 to 4.0 by adding 0.5 CPU each time. The RAM is assigned from range of 500 MB to 4000 MB by adding 500 MB RAM each time.
The cartesian join of these two variables result in 64 individual experiements for the first experiment.

The second experiemnt consider CPU and RAM as constant, and it calculate the DFGs based on sub-set of events. The repository is diced by filtering events by one day. Then, the dicing is continued by adding more days to the filter in an accumulative way to increase the number of events. As the number of events per day are not increased constantly, we use the number of events which was filtered for analysis.

You can create this experiement list by hand, but if you like, you can run this python script to give you all required experiemnts. You can alter the parameters if you like as well.

In total, 188 experiement is performed in the evaluation. The list can be found in experiement_list dataframe by executing this code:

``` Python
import numpy as np
import pandas as pd
import datetime

CPU_min = 0.5
CPU_max = 4

RAM_min = 512
RAM_max = 4096

column_list = ['Experiment Number', 'Container', 'CPU', 'RAM', 'End Date']

start_date = "7/1/2015"
start_date = datetime.datetime.strptime(start_date, "%m/%d/%Y")

containers = ['neo4j', 'PM4Py']

experiement_list = pd.DataFrame(columns=column_list)

for cpu in np.arange(CPU_min, CPU_max+CPU_min, CPU_min):
    for ram in np.arange(RAM_min, RAM_max+RAM_min, RAM_min):
        for cont in containers:
            row = pd.DataFrame(np.array([['1', cont, cpu, ram, np.NaN]]), columns=column_list)
            experiement_list = experiement_list.append(row)

for i in range(0,30):
    end_date = start_date + datetime.timedelta(days=i)
    for cont in containers:
        row = pd.DataFrame(np.array([['2', cont, CPU_max, RAM_max, end_date.date()]]), columns=column_list)
        experiement_list = experiement_list.append(row)   
```

## select an experiment from the list
Now, you need to select one of the experiemensts in the experiement list.

## setup the environment

There are two different conatainser which are used in this study, i.e., neo4j and PM4Py. You need to run different containers and set the cpu and memory limits for it depends on the conatiner type that you create.

### neo4j


If you are creating an experiment for neo4j, you can run the conatiner using these commands:

```
cd '[Write the Volume directory]'
$root_dir = pwd
$cpu=[Write the CPU parameter]
$neo_mem=[Write the RAM parameter]
$memory = -join('"', $neo_mem, 'm"')
docker run --name analysis --cpus $cpu --env CPU_LIMIT=$cpu --memory=$memory --env MEMORY_LIMIT=$memory -e NEO4J_AUTH=neo4j/1234 --env NEO4J_HEAP_MEMORY=$neo_mem --env NEO4J_CACHE_MEMORY=$memory --publish=7474:7474 --publish=7687:7687 -v $root_dir/data:/data  neo4j:latest 
```

### PM4Py
If you are creating an experiment for PM4Py, you can run the conatiner using these commands:

```
cd '[Write the Volume directory in which your data and import folders for neo4j are created]'
$root_dir = pwd

$cpu=[Write the CPU parameter]
$py_mem=[Write the RAM parameter]
$memory = -join('"', $py_mem, 'm"')

docker run --name analysis --cpus $cpu --env CPU_LIMIT=$cpu --memory=$memory --env MEMORY_LIMIT=$memory -v $root_dir/log:/data -d --rm -p 5000:5000 aminjalali/pm4py-jupyter
docker logs analysis
docker rm -f $(docker ps -aq)

```

We created another image from PM4Py to enable using jupyter lab for analysis.

## run the experiment

There are different python scripts that you should execute for different containers to calculate the DFG. The resutl are saved into the persisted volume for the final analysis, which is shown by Experiments result in the BPMN process. 

### Experiment 1
If the selected experiment is for experiment 1, one of these python script shall be executed depends on the sort of container.
  * For calculating DFG using neo4j, use [experiement1_neo4j.ipynb](./experiment1/experiement1_neo4j.ipynb)
  * For calculating DFG using pm4py, use [experiement1_pm4py.ipynb](./experiment1/experiement1_neo4j.ipynb)


### Experiment 2
 If the selected experiment is for experiment 2, one of these python script shall be executed depends on the sort of container.
  * For calculating DFG using neo4j, use 
  * For calculating DFG using pm4py, use 

## remove the experiment from the list

## compare the result


# Note on the process
The process for evaluation can be done manually or automatically. We described the manual version. The same procedure can be followed if you develop the build and release pipeline in DevOps to create containers, perform experiments and store the result.

events:
9329053
