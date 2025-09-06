#!/usr/bin/env python3
import qarnot
import os, string, random

#######################################################################
## This section shows how to setup the script for your situation.    ##
#######################################################################

# Your email address (as registed with Qarnot)
user = 'samuel.lazerson@gauss-fusion.com'

# Registry information
docker_server='https://containers.qarnot.com'
docker_registry='samuelgaussf'

# Choose your Docker image
docker_image = 'roce_mpi_test'

# Choose your Docker image tag
docker_tag = 'latest'

# Short descriptive name of your run
task_name = 'roce_mpi_test'

# Inputs to the Fieldlines code
input_ext = ''
options = ''

# Command you'd like the code to run
task_cmd = f'xtest_program'

# List of files to upload as input
input_files = []

# Number of nodes
nnodes = 1


#######################################################################
##                      NO EDITING BELOW                             ##
#######################################################################

# CREATE A UNIQUE ID
jobid='_'+''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(6))
task_name = task_name+jobid

# Evntually movethis stuff up bur for now keep here.
task_prof = 'gauss-fusion'

# MPIEXEC
mpi_cmd = "mpiexec --allow-run-as-root --bind-to none --mca btl ^openib --hostfile /job/mpihosts -x UCX_NET_DEVICES -x UCX_IB_SL -x UCX_IB_TRAFFIC_CLASS "

# Snaphot interval in s
snapshot_time = 300

# Create connection
print(' -- Connecting to Qarnot')
conn = qarnot.connection.Connection(client_token=os.getenv("QARNOT_API_KEY"))
print(' -- Connection established')

# Create Input bucket
print(' -- Input bucket creation')
input_bucket = conn.create_bucket(f'{task_name}-input-bucket')
for filename in input_files:
	print(f'      Adding {filename}')
	input_bucket.add_file(filename)
print(' -- Input bucket created')

# Create output bucket
print(' -- Output bucket creation')
output_bucket = conn.create_bucket(f'{task_name}-output-bucket')
print(' -- Output bucket created')

# Create task
print(f' -- Task creation {task_name} {task_prof}')
task = conn.create_task(task_name, task_prof, nnodes)
task.constants['DOCKER_SRV'] = docker_server
task.constants['DOCKER_REPO'] = rf'{docker_registry}/{docker_image}'
task.constants['DOCKER_TAG'] = docker_tag
task.constants['DOCKER_CMD_MASTER'] = rf"/bin/bash -lc '/qarnot/utils/setup_cluster $({mpi_cmd} {task_cmd}  2>&1 | tee -a ./log_{task_name}.txt)'"
task.constants['DOCKER_CMD_WORKER'] = rf"/bin/bash -c '/qarnot/utils/setup_cluster'"
task.constants['DOCKER_REGISTRY_LOGIN'] = user
task.constants['QARNOT_SECRET__DOCKER_REGISTRY_PASSWORD']=os.getenv("QARNOT_REGISTRY_KEY")
task.resources.append(input_bucket)
task.results = output_bucket
task.snapshot(snapshot_time)
print(f' -- Using image {docker_registry}/{docker_image}:{docker_tag}')
print(f' -- Task created {task.constants['DOCKER_CMD_MASTER']}')


# run task
print(' -- Task execution')
task.run(live_progress=True,follow_state=True,follow_stdout=True,follow_stderr=True)
task.update()
print(f' -- Task Complete: {task.state}')

if task.state == 'Success':
	print(' -- Downloading Output Bucket')
	output_bucket.get_all_files('./', progress=True)
