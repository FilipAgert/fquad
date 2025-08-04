# Paths
DSRC = src
DOBJ = build
DEXE = app
DMOD = mod
EXEN = fquad
all: $(DEXE)/$(EXEN)
# Flags
LIBS = 
FLAGREL = -O3 -I$(DOBJ) -I$(DMOD) -fcheck=all -fbacktrace -g -ffree-line-length-none -fimplicit-none
FLAGDEV = -O2 -I$(DOBJ) -I$(DMOD) -fbacktrace -g -fno-omit-frame-pointer -ffree-line-length-none -fimplicit-none
FLAGS = $(FLAGDEV)
CC = gfortran $(FLAGS) -J$(DMOD) $(LIBS) -c
CCL = gfortran -o

# Objects
OBJECTS = $(DOBJ)/quad.o
MAIN_OBJ = $(DOBJ)/main.o

VPATH = $(DSRC):$(DTEST):$(DSRC)/$(DSH)

$(DOBJ)/main.o: $(DSRC)/main.f90 $(DOBJ)/quad.o

# Default target



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

runcallgrind:
	@name="callgrind.out.$(EXEN)"; \
	n=0; \
	filename="$$name"; \
	while [ -e "$$filename" ]; do \
		n=$$((n+1)); \
		filename="$$name\_$$n"; \
	done; \
	echo "Saving callgrind output to $$filename"; \
	valgrind --tool=callgrind --callgrind-out-file=$$filename $(DEXE)/$(EXEN); \
	kcachegrind $$filename

clean:
	rm -rf $(DOBJ)/*.o $(DEXE)/* $(DMOD)/*.mod *.dat 

.PHONY: all clean run main
