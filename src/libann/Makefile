include $(MAKECONF)

LIBOUT = lib/libann.a

LIBOBJS = \
	src/ANN.o \
	src/brute.o \
	src/kd_tree.o \
	src/kd_util.o \
	src/kd_split.o \
	src/kd_dump.o \
	src/kd_search.o \
	src/kd_pr_search.o \
	src/kd_fix_rad_search.o \
	src/bd_tree.o \
	src/bd_search.o \
	src/bd_pr_search.o \
	src/bd_fix_rad_search.o \
	src/perf.o

.PHONY: all clean

all: $(LIBOUT)

$(LIBOUT): $(LIBOBJS)
	mkdir -p lib
	$(AR) -rcs $(LIBOUT) $^

%.o: %.cpp
	$(CXX) -c $(ALL_CPPFLAGS) $(ALL_CXXFLAGS) -DNDEBUG -Iinclude -Wno-unused-const-variable $< -o $@

clean:
	$(RM) -rf lib src/*.o
