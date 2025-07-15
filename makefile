# paths
DSRC = ./src
DOBJ = ./build
DEXE = ./app
DTEST = ./tests

EXEN = main.exe
TEST_EXE = test.exe

# flags
FLAGS = -Wall -O3 -I$(DSRC) -I$(DOBJ)
LIBS =  # Google Test and pthread libs

# commands for compilation
CCL = gfortran -o
CC = gfortran $(FLAGS)

# objects
OBJECTS = 
MAIN_OBJ = $(DOBJ)/main.o
TEST_OBJECTS =  

# Targets
main: $(DEXE)/$(EXEN)

# Link the main executable
$(DEXE)/$(EXEN): $(OBJECTS) $(MAIN_OBJ)
	$(CCL) $@ $(MAIN_OBJ) $(OBJECTS) $(LIBS)

# Test executable target
$(DEXE)/$(TEST_EXE): $(TEST_OBJECTS) $(OBJECTS)
	$(CCL) $@ $(TEST_OBJECTS) $(OBJECTS) $(LIBS)

# Compile test object files (from ./test folder)
$(DOBJ)/%.o: $(DTEST)/%.f90
	$(CC) -I$(DOBJ) -I$(GTEST_INCLUDE_DIR) -c $< -o $@

# Compile source object files (from ./src folder)
$(DOBJ)/%.o: $(DSRC)/%.f90
	$(CC) -I$(DOBJ) -c $< -o $@

# Clean up build artifacts
clean:
	rm -rf $(DOBJ)/*.o $(DEXE)/*.exe

# Run the main executable
run: main
	cd $(DEXE); \
	./$(EXEN)

# Run all tests
test: $(DEXE)/$(TEST_EXE)
	./$(DEXE)/$(TEST_EXE)  # Run the test executable
