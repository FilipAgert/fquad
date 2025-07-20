# Paths
DSRC = src
DOBJ = build
DEXE = app
DMOD = mod
EXEN = main.exe

# Flags
LIBS = 
FLAGS = -O3 -I$(DOBJ) -I$(DMOD) -ffree-line-length-none -fimplicit-none
CC = gfortran $(FLAGS) -J$(DMOD) $(LIBS) -c
CCL = gfortran -o

# Objects
OBJECTS = $(DOBJ)/quad.o
MAIN_OBJ = $(DOBJ)/main.o

VPATH = $(DSRC):$(DTEST):$(DSRC)/$(DSH)

$(DOBJ)/main.o: $(DSRC)/main.f90 $(DOBJ)/quad.o

# Default target
all: main

$(DOBJ)/%.o: %.f90 | $(DOBJ) $(DMOD)
	$(CC) $< -o $@

# Ensure required directories exist
$(DOBJ) $(DEXE) $(DMOD):
	mkdir -p $@

# Targets
$(DEXE)/$(EXEN): $(MAIN_OBJ) $(OBJECTS) | $(DEXE)
	$(CCL) $@ $(MAIN_OBJ) $(OBJECTS) $(LIBS)

main: $(DEXE)/$(EXEN)

run: $(DEXE)/$(EXEN)
	$(DEXE)/$(EXEN) $(ARG1) $(ARG2)



clean:
	rm -rf $(DOBJ)/*.o $(DEXE)/*.exe $(DMOD)/*.mod
