#!/bin/sh

set -ev

# Environment variables
export CXXFLAGS="-mno-avx"
if [ "$CXX" = "g++" ]; then
    export CC=/usr/bin/gcc-$GCC_VERSION
    export CXX=/usr/bin/g++-$GCC_VERSION
else
    export CC=/usr/bin/clang-$CLANG_VERSION
    export CXX=/usr/bin/clang++-$CLANG_VERSION
fi

cd ${BUILD_PREFIX}

##########   test with blas+lapack   ##########
mkdir build_cblas
cd build_cblas
cmake ${TRAVIS_BUILD_DIR} -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBTAS_ASSERT_THROWS=ON -DBoost_FOUND=ON -DBoost_INCLUDE_DIRS=/usr/include/boost -DBoost_LIBRARIES=/usr/lib/x86_64-linux-gnu/libboost_serialization.a -DSKIP_BOOST_SEARCH=ON
make VERBOSE=1
make check VERBOSE=1
cd ..

########## test without blas+lapack   ##########
mkdir build
cd build
cmake ${TRAVIS_BUILD_DIR} -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBTAS_ASSERT_THROWS=ON -DBTAS_USE_CBLAS_LAPACKE=OFF  -DBoost_FOUND=ON -DBoost_INCLUDE_DIRS=/usr/include/boost -DBoost_LIBRARIES=/usr/lib/x86_64-linux-gnu/libboost_serialization.a -DSKIP_BOOST_SEARCH=ON
make VERBOSE=1
make check VERBOSE=1
cd ..

