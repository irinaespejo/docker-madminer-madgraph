#
# Dockerfile for MG5 Pythia Delphes and patches for Madminer deployment
#

FROM rootproject/root-ubuntu16 

USER root 

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    wget ca-certificates python gfortran build-essential ghostscript vim libboost-all-dev


#
# MadGraph + Pythia + Delphes
#

WORKDIR /home/software

ENV MG_VERSION="MG5_aMC_v2_6_2" 

RUN git clone https://github.com/irinaespejo/${MG_VERSION}.git &&\
	./${MG_VERSION}/bin/mg5_aMC

WORKDIR /home/software/${MG_VERSION}

ENV ROOTSYS /usr/local 
ENV PATH $PATH:$ROOTSYS/bin 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ROOTSYS/lib 

RUN echo "install lhapdf6" | /home/software/${MG_VERSION}/bin/mg5_aMC
RUN echo "install pythia8" | /home/software/${MG_VERSION}/bin/mg5_aMC
RUN echo "install pythia-pgs" | /home/software/${MG_VERSION}/bin/mg5_aMC
RUN echo "install Delphes" | /home/software/${MG_VERSION}/bin/mg5_aMC

#disable autoupdate MG
RUN rm /home/software/${MG_VERSION}/input/.autoupdate


#
# patches for Madminer
#

WORKDIR /home/software

#add patches folder
COPY patch/ ./patch

#running patch.py requires being in the directory
WORKDIR /home/software/patch

ENV MG_PATH /home/software/${MG_VERSION}

#run patches with MG directory
RUN python patch.py ${MG_PATH}
