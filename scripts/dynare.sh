#!/bin/bash

THIS_SCRIPT_PATH=$(dirname $(readlink -f "$0"))
ROOT_PATH=$(dirname $(readlink -f $THIS_SCRIPT_PATH/../matlab.mk.example))
DYNARE_PATH=$ROOT_PATH/modules/dynare

if [ -f $ROOT_PATH/matlab.mk ] ;
then
    echo ${ROOT_PATH}/matlab.mk
    source ${ROOT_PATH}/matlab.mk
else
  echo ""
  echo "Missing configuration file for matlab!"
  echo ""
  echo "You need to write a configuration file, where the matlab path and version are"
  echo "are defined. First do:"
  echo ""
  echo " ~$ cp matlab.mk.example matlab.mk"
  echo ""
  echo "in the root folder, and adapt the content of this file to your system."
  echo "" 
  exit 0
fi

CURRENT_PATH=$(pwd)
cd ${DYNARE_PATH}
git submodule update --recursive --init
autoreconf -si
./configure --with-matlab=${MATLABPATH} MATLAB_VERSION=${MATLABVERS} CXXFLAGS="-O3" CFLAGS="-O3" F77="gfortran" FFLAGS="-O3" --enable-openmp --disable-octave
make -j4 all
cd ${CURRENT_PATH}
