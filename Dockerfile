# Debian image of install
FROM containers.qarnot.com/samuelgaussf/roce.base:ubuntu-24.04 AS lib


#Copy in files and set workdir
COPY . /app
WORKDIR /app

# We need to alias the python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# We should add the openmpi bin to path
ENV PATH="/opt/openmpi/bin:$PATH"

# Build the code
RUN FC=/opt/openmpi/bin/mpif90 make

# Copy the file
RUN cp -RP /app/xtest_program /usr/local/bin
