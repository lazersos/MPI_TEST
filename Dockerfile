# Debian image of install
FROM containers.qarnot.com/samuelgaussf/roce.base:ubuntu-24.04 AS lib


#Copy in files and set workdir
COPY . /app
WORKDIR /app

# Get missing library
RUN apt-get update && apt-get install -y libnuma-dev

# We need to alias the python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Build the code
RUN FC=/opt/openmpi/bin/mpif90 make

# Copy the file
RUN cp -RP /app/xtest_program /usr/local/bin

# Fix the permissions on some files
RUN chmod +x /qarnot/utils/print_info
RUN chmod +x /qarnot/utils/run_task
RUN chmod +x /qarnot/utils/slot_scheduler

# Add libnuma-dev to path
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
