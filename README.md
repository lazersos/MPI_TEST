# ROCE MPI Test

A simple MPI test program designed to validate MPI functionality across different systems, with specific support for containerized deployment on the Qarnot cloud computing platform.

## Overview

This repository contains a minimal Fortran MPI test program that reports MPI configuration details including version, library information, process counts, and shared memory configuration. It's designed to help validate MPI setups in various environments, particularly for testing ROCE (RDMA over Converged Ethernet) configurations.

## Features

- **Simple MPI Test**: Basic Fortran program that exercises core MPI functionality
- **System Information**: Reports MPI version, library details, and process topology
- **Containerized Deployment**: Docker support for consistent deployment across environments
- **Cloud Ready**: Integration with Qarnot cloud computing platform
- **Cross-Platform**: Works on various MPI implementations and systems

## Quick Start

### Local Build and Run

1. **Prerequisites**:
   - MPI implementation (OpenMPI, MPICH, Intel MPI, etc.)
   - Fortran compiler with MPI support
   - Make

2. **Build**:
   ```bash
   make
   ```

3. **Run locally**:
   ```bash
   mpirun -np 4 ./xtest_program
   ```

### Docker Build

1. **Build the Docker image**:
   ```bash
   python3 build_docker.py
   ```
   
   This script will:
   - Build a Docker image based on Ubuntu 24.04 with OpenMPI
   - Tag it with the current date
   - Push to the configured container registry

2. **Run in container**:
   ```bash
   docker run --rm your-registry/roce_mpi_test:latest
   ```

### Qarnot Cloud Deployment

1. **Setup environment variables**:
   ```bash
   export QARNOT_API_KEY="your-api-key"
   export QARNOT_REGISTRY_KEY="your-registry-key"
   ```

2. **Run on Qarnot**:
   ```bash
   cd example_run
   python3 run_test_on_qarnot.py
   ```

## File Structure

```
├── Dockerfile              # Container definition
├── Makefile                # Build configuration
├── build_docker.py         # Docker build and push script
├── test_program.f90        # Main MPI test program
├── example_run/
│   └── run_test_on_qarnot.py  # Qarnot cloud execution script
└── .gitignore              # Git ignore patterns
```

## Program Output

The test program outputs MPI configuration information:

```
-----  MPI Parameters  -----
   MPI_version:  3.01
   Open MPI v4.1.4, package: Open MPI Distribution, ident: 4.1.4, repo rev: v4.1.4, date: May 26, 2022
   Nproc_total:      4
   Nproc_shared:     4
```

## Configuration

### Docker Configuration

The Docker image is based on a custom Ubuntu 24.04 image with OpenMPI pre-installed. Key configurations:

- Base image: `containers.qarnot.com/samuelgaussf/roce.base:ubuntu-24.04`
- MPI: OpenMPI installed in `/opt/openmpi`
- Compiler: `mpif90` (OpenMPI Fortran wrapper)

### Qarnot Configuration

Edit `example_run/run_test_on_qarnot.py` to customize:

- **Docker settings**: Registry, image name, and tag
- **Compute resources**: Number of nodes (`nnodes`)
- **MPI settings**: Command-line options for `mpiexec`
- **User credentials**: Email and registry information

Key MPI options for ROCE environments:
```bash
mpiexec --allow-run-as-root --bind-to none --mca btl ^openib --hostfile /job/mpihosts -x UCX_NET_DEVICES -x UCX_IB_TRAFFIC_CLASS
```

## Requirements

### Local Development
- Fortran compiler (gfortran, ifort, etc.)
- MPI implementation
- Make

### Containerized Deployment
- Docker
- Python 3 with `docker` package
- Access to container registry

### Qarnot Cloud
- Qarnot account and API key
- Python 3 with `qarnot` package
- Container registry access

## Author

**Samuel Lazerson**  
Date: September 6, 2025

## License

This project is part of a test suite for MPI functionality validation across different computing environments.

## Contributing

This is a test program designed for specific validation purposes. If you need to modify the test parameters or add functionality:

1. Fork the repository
2. Make your changes
3. Test locally and in your target environment
4. Submit a pull request

## Troubleshooting

### Common Issues

1. **MPI not found**: Ensure MPI is properly installed and `mpif90` is in your PATH
2. **Docker build fails**: Check base image availability and network connectivity
3. **Qarnot execution fails**: Verify API keys and registry credentials
4. **Permission errors in container**: The Docker configuration uses `--allow-run-as-root` for compatibility

### Debugging

- Check MPI installation: `mpif90 --version`
- Test Docker build locally before pushing
- Monitor Qarnot task logs for detailed error information
- Verify environment variables are set correctly

For more specific issues, consult the MPI implementation documentation or Qarnot platform support.
