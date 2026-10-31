# ---------------------------------------------------------------------------
# Makefile for a C program (Windows/MinGW, Linux, macOS)
#
#   make          build the program
#   make run      build, then run it
#   make clean    delete the program and object files
#
# It builds one file, helloworld.c. For a multi-file program, add the
# source files to SRCS.
#
# C++: the lines marked "C++:" show what to change.
# ---------------------------------------------------------------------------

# Name of the program (".exe" is added on Windows).
TARGET := helloworld

# Source files. For a multi-file program, list them all:
#   SRCS := main.c greet.c util.c
# C++: SRCS := helloworld.cpp
SRCS := helloworld.c

CC     := gcc
CFLAGS := -g -Wall -Wextra -std=c11
# C++: use these instead:
# CXX      := g++
# CXXFLAGS := -g -Wall -Wextra -std=c++17

# Libraries to link, e.g. -lm for the math library.
LDLIBS :=

# One object file per source file: helloworld.c -> helloworld.o
OBJS := $(SRCS:.c=.o)
# C++: OBJS := $(SRCS:.cpp=.o)

# Windows programs end in .exe.
ifeq ($(OS),Windows_NT)
    EXE := .exe
endif
PROGRAM := $(TARGET)$(EXE)

all: $(PROGRAM)

# Link the object files into the program.
$(PROGRAM): $(OBJS)
	$(CC) $(OBJS) -o $(PROGRAM) $(LDLIBS)
# C++: link with g++:
#	$(CXX) $(OBJS) -o $(PROGRAM) $(LDLIBS)

# Compile each .c file into a .o file.
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
# C++: compile .cpp files with g++:
# %.o: %.cpp
#	$(CXX) $(CXXFLAGS) -c $< -o $@

# Headers: make doesn't see #include lines, so list which object files
# depend on which headers, and they are rebuilt when the header changes:
#   main.o greet.o: greet.h

run: $(PROGRAM)
	./$(PROGRAM)

clean:
	rm -f $(PROGRAM) $(OBJS)

.PHONY: all run clean