# VM-prepare

## Requirements
git

## Usage
Clone the repository:
```
git clone https://github.com/Rcarnus/VM-prepare.git
```
Modify the TOOLSFOLDER variable in the script to point where you want the tools to be installed on the file system.

Run the tool as low priv user:
```
cd VM-prepare/
./vm-prepare.sh
```

Run the vm-prepare.sh tool one first time to install the requirements:
```
./vm-prepare.sh firsttime
```

Install all the tools
```
./vm-prepare.sh all
```
