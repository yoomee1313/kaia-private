# ARCHIVED
This repo is archived. Please use https://github.com/kaiachain/kaiaspray/tree/main/local-deploy instead.

# kaia-private
easy launching a private network of kaia (macOS)

## How-to-build?
The `1_copy_binary.sh` script copies the built binaries from the local kaia directory. It might be cloned from the remote repository: https://github.com/kaiachain/kaia.git

Before building the binaries, please check that you have installed all the dependencies required: go1.22 or above, gcc, Makefile. 
To build the binaries, navigate to the $KAIACODE directory, and execute `make all` or `make ken`. Make sure they have been built.
```shell
cd $KAIACODE
make all && ls -al build/bin
drwxr-xr-x   6 user  staff       192 Jul  1 11:17 .
drwxr-xr-x  34 user  staff      1088 May 31 11:43 ..
-rwxr-xr-x   1 user  staff  68307266 Jun 24 13:35 homi
-rwxr-xr-x   1 user  staff  71114354 Jun 24 15:09 kcn
-rwxr-xr-x   1 user  staff  71114354 Jul  1 11:17 ken
-rwxr-xr-x   1 user  staff  71114354 Jun 24 15:09 kpn
...
```

## How-to-deploy?
Configure the variables in `properties.sh` with the guide below and execute the scripts in sequence
```shell
# set up the directories
KAIACODE=$HOME/workdir/kaia # rewrite the path for your kaia code. The built binary will be copied from here.
HOMEDIR=$HOME/workdir/kaia-private # rewrite the path for the current project.
```
```shell
# set up some options
NETWORK_ID=292929 # assign a random NETWORK_ID. 582737, 2342, 128495
NUMOFCN=1 # number of consensus nodes you want to launch
NUMOFPN=1 # number of proxy nodes you want to launch
NUMOFEN=1 # number of endpoint nodes you want to launch
NUMOFTESTACCSPERNODE=1 # number of test accounts. they will have a lot of KAIA.
```

There are 7 scripts. `./0_setup.sh` only needs to be executed whenever you want to set up the node directories from the beginning. If ${nodetype} and ${nodenum} defined, it will target a specific node, otherwise it will target whole network.
However, `5_attach.sh and 6_logs.sh` only work with a single node.
* `./0_setup.sh deploy`: set up the node directories as configured at properties.sh
* `./1_copy_binary.sh ${nodetype} ${nodenum}`: copy the binary to the node directories
* `./2_initialize_nodes.sh ${nodetype} ${nodenum}`: delete all nodes data and execute `init` to set up the genesis data
* `./3_ccstart.sh ${nodetype} ${nodenum}`: start the nodes
* `./4_ccstop.sh ${nodetype} ${nodenum}`: stop the nodes
* `./5_attach.sh ${nodetype} ${nodenum} ${attach-type}`: attach to the ipc or rpc or ws of specific node

Examples
```shell
./1_copy_binary.sh en 1
./3_ccstart.sh en 1
./5_attach.sh en 1 rpc
```

