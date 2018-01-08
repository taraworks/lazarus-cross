### Cross compiling hello world with Docker image and Free Pascal Compiler 3.0.4

#### 1. pull docker image:

*sudo docker pull taraworks/lazarus-cross:0.0.2*  (do not use latest)

#### 2. create container with virtual volume based on the pulled image:

a. identify image ID (first 4 digits are needed):
*sudo docker images*

b. use the image for the container, map virtual volume from host:
*sudo docker create --name pascalContainer -v /home/tudi/pascal_files:/home/tudi/pascal_files -ti image ID*

#### 3. start the container
a. identify container ID (first 4 digits are needed):
*sudo docker ps -a*

b. start container: 
*sudo docker start container ID*

#### 4. compile file
a. copy pascal file hello.pas from https://github.com/taraworks/lazarus-cross to folder /home/tudi/pascal_files on host:

run on host:

*cd /home/tudi/pascal_files*

*git clone https://github.com/taraworks/lazarus-cross.git*

b. attach to container to check the cloned repo is presented:

run on host:

*sudo docker attach container ID*

press enter one more time and check hello.pas is in container folder.
do not detach with exit from container as container will stop.

c. compile from container. change directory to the folder containing hello.pas:

for Windows:

*PATH=$PATH:/opt/clang/bin:/opt/osxcross/target/bin /opt/windows/lib/fpc/3.0.4/ppcross386 -Twin32 -va hello.pas*

for OSX:

*PATH=$PATH:/opt/clang/bin:/opt/osxcross/target/bin /opt/darwin/lib/fpc/3.0.4/ppcross386 -Tdarwin -XR/opt/osxcross/target/SDK/MacOSX10.11.sdk -va hello.pas*

d. compile from host. 

*sudo docker exec pascalContainer bash -c "cd ${CI_PROJECT_DIR} && PATH=$PATH:/opt/clang/bin:/opt/osxcross/target/bin /opt/windows/lib/fpc/3.0.4/ppcross386 -Twin32 -va /home/tudi/pascal_files/lazarus-cross/hello.pas"*


