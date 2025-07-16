# Paths
DSRC = src
DOBJ = build
DEXE = app
DTEST = tests
DMOD = mod
EXEN = main.exe
TEST_EXE = test.exe

# Flags
LIBS = 
FLAGS = -O3 -I$(DOBJ) -I$(DMOD) -ffree-line-length-none -fcheck=all -fbacktrace -g -fimplicit-none -fno-omit-frame-pointer
CC = gfortran $(FLAGS) -J$(DMOD) $(LIBS) -c
CCL = gfortran -o

# Objects
OBJECTS = $(DOBJ)/quad.o
TEST_OBJECTS = 
MAIN_OBJ = $(DOBJ)/main.o
TEST_OBJ = 

VPATH = $(DSRC):$(DTEST):$(DSRC)/$(DSH)

$(DOBJ)/main.o: $(DSRC)/main.f90 $(DOBJ)/quad.o

# Default target
all: main

$(DOBJ)/%.o: %.f90 | $(DOBJ) $(DMOD)
	$(CC) $< -o $@



# Ensure required directories exist
$(DOBJ) $(DEXE) $(DMOD) $(DTEST):
	mkdir -p $@

# Targets
$(DEXE)/$(EXEN): $(MAIN_OBJ) $(OBJECTS) | $(DEXE)
	$(CCL) $@ $(MAIN_OBJ) $(OBJECTS) $(LIBS)

$(DEXE)/$(TEST_EXE): $(TEST_OBJ) $(OBJECTS) $(TEST_OBJECTS) | $(DEXE)
	$(CCL) $@ $(TEST_OBJ) $(OBJECTS) $(TEST_OBJECTS) $(LIBS)

main: $(DEXE)/$(EXEN)

run: $(DEXE)/$(EXEN)
	$(DEXE)/$(EXEN)

test: $(DEXE)/$(TEST_EXE)
	$(DEXE)/$(TEST_EXE)

clean:
	rm -rf $(DOBJ)/*.o $(DEXE)/*.exe $(DMOD)/*.mod
