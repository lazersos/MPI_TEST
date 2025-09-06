!-----------------------------------------------------------------------
!     Program:       TEST_PROGRAM
!     Authors:       Samuel Lazerson
!     Date:          09/06/2025
!     Description:   Simple program to test MPI on various systems.
!-----------------------------------------------------------------------
PROGRAM TEST_PROGRAM
    !-------------------------------------------------------------------
    !     Libraries
    !-------------------------------------------------------------------
    USE mpi

    !-------------------------------------------------------------------
    !     Local Variables
    !-------------------------------------------------------------------
    IMPLICIT NONE
    INTEGER, PARAMETER :: master = 0
    INTEGER            :: ierr_mpi
    INTEGER            :: MPI_COMM_PROGRAM
    INTEGER            :: vmajor
    INTEGER            :: vminor
    INTEGER            :: liblen
    INTEGER            :: myworkid
    INTEGER            :: nprocs
    INTEGER            :: MPI_COMM_SHARMEM
    INTEGER            :: myid_sharmem
    INTEGER            :: nshar
    CHARACTER(LEN=MPI_MAX_LIBRARY_VERSION_STRING) :: mpi_lib_name


    !-------------------------------------------------------------------
    !     Begin Program
    !-------------------------------------------------------------------
    myworkid = master
    ierr_mpi = 0
    CALL MPI_INIT(ierr_mpi) ! MPI
    CALL MPI_COMM_DUP( MPI_COMM_WORLD, MPI_COMM_PROGRAM, ierr_mpi)
    CALL MPI_COMM_RANK(MPI_COMM_PROGRAM, myworkid, ierr_mpi) ! MPI
    CALL MPI_COMM_SIZE(MPI_COMM_PROGRAM, nprocs, ierr_mpi) ! MPI
    CALL MPI_GET_VERSION(vmajor,vminor,ierr_mpi)
    CALL MPI_GET_LIBRARY_VERSION(mpi_lib_name,liblen,ierr_mpi)
    CALL MPI_COMM_SPLIT_TYPE(MPI_COMM_PROGRAM, MPI_COMM_TYPE_SHARED, 0, MPI_INFO_NULL, MPI_COMM_SHARMEM, ierr_mpi)
    CALL MPI_COMM_RANK(MPI_COMM_SHARMEM, myid_sharmem, ierr_mpi)
    CALL MPI_COMM_SIZE(MPI_COMM_SHARMEM, nshar, ierr_mpi) ! MPI
    IF (myworkid == master) THEN
        WRITE(6,'(A)')           '-----  MPI Parameters  -----'
        WRITE(6,'(A,I2,A,I2.2)') '   MPI_version:  ', vmajor,'.',vminor
        WRITE(6,'(A,A)')         '   ', TRIM(mpi_lib_name(1:liblen))
        WRITE(6,'(A,I8)')        '   Nproc_total:  ', nprocs
        WRITE(6,'(A,3X,I5)')     '   Nproc_shared: ', nshar
    END IF
    CALL MPI_BARRIER(MPI_COMM_SHARMEM, ierr_mpi)
    CALL MPI_COMM_FREE(MPI_COMM_SHARMEM, ierr_mpi)
    CALL MPI_BARRIER(MPI_COMM_PROGRAM, ierr_mpi)
    CALL MPI_COMM_FREE(MPI_COMM_PROGRAM, ierr_mpi)
    CALL MPI_FINALIZE(ierr_mpi)
    !-------------------------------------------------------------------
    !     End Program
    !-------------------------------------------------------------------
END PROGRAM TEST_PROGRAM