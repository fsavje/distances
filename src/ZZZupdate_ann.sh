#!/bin/sh

rm -rf libann
mkdir libann
wget https://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.zip
unzip -q ann_1.1.2.zip
rm ann_1.1.2/src/Makefile
cp -R ann_1.1.2/include ann_1.1.2/src ann_1.1.2/Copyright.txt ann_1.1.2/License.txt libann
rm -rf ann_1.1.2 ann_1.1.2.zip

ed -s libann/include/ANN/ANN.h <<EOF
,s/#define DLL_API __declspec(dllexport)/#define DLL_API/g
,s/#define DLL_API __declspec(dllimport)/#define DLL_API/g
,w
q
EOF

ed -s libann/include/ANN/ANNperf.h <<EOF
,s/double stdDev() { return sqrt/double stdDev() { return std::sqrt/g
,w
q
EOF

ed -s libann/src/kd_dump.cpp <<EOF
,s/const double	EPSILON			= 1E-5;/\/\/const double	EPSILON			= 1E-5;/g
,w
q
EOF

cat <<EOF > libann/Makefile
include \$(MAKECONF)

ALL_CXX98FLAGS = \$(R_XTRA_CXXFLAGS) \$(PKG_CXXFLAGS) \$(CXX98PICFLAGS) \$(SHLIB_CXXFLAGS) \$(CXX98FLAGS)

LIBOUT = lib/libann.a

LIBOBJS = \\
	src/ANN.o \\
	src/brute.o \\
	src/kd_tree.o \\
	src/kd_util.o \\
	src/kd_split.o \\
	src/kd_dump.o \\
	src/kd_search.o \\
	src/kd_pr_search.o \\
	src/kd_fix_rad_search.o \\
	src/bd_tree.o \\
	src/bd_search.o \\
	src/bd_pr_search.o \\
	src/bd_fix_rad_search.o \\
	src/perf.o

.PHONY: all clean

all: \$(LIBOUT)

\$(LIBOUT): \$(LIBOBJS)
	mkdir -p lib
	\$(AR) -rcs \$(LIBOUT) \$^

%.o: %.cpp
	\$(CXX98) -c \$(CXX98STD) \$(ALL_CPPFLAGS) \$(ALL_CXX98FLAGS) -DNDEBUG -Iinclude $< -o \$@

clean:
	\$(RM) -rf lib src/*.o
EOF
