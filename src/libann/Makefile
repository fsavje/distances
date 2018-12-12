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

libann.a: $(LIBOBJS)
	$(R_AR) -rcs libann.a $^

.cpp.o:
	$(R_CXX) $(R_CPPFLAGS) $(R_CXXFLAGS) -Iinclude -c $< -o $@

clean:
	$(R_RM) libann.a $(LIBOBJS)

.PHONY: clean
