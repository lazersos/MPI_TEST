FC=mpif90
FFLAGS=
LDFLAGS=

OBJ=test_program.o

EXE_NAME=xtest_program

%.o: %.f90
	$(FC) -c -o $@ $< $(FFLAGS)

$(EXE_NAME): $(OBJ)
	$(FC) -o $@ $^ $(LDFLAGS) $(LIBS)
