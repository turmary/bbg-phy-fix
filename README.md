# bbg-phy-fix

BBB/BBG ethernet phy sometimes don't works, refer this [issue](https://github.com/RobertCNelson/Bootloader-Builder/issues/10)

This patch used to fix the problem through a image update for convenience, 
the patch source is [here](https://github.com/turmary/Bootloader-Builder/commit/328b721d2a3bb5d15c2cd07fb9ffb5be0606d6c8).

## Usage
```bash
# Internet connection is needed, bash environment, please copy only to avoid typo

# Method 1
# single command line
sudo sh -c "wget -q -O - https://raw.githubusercontent.com/turmary/bbg-phy-fix/master/phy-fix.sh | bash"

# Method 2
# the equal mutliple commands
sudo wget https://raw.githubusercontent.com/turmary/bbg-phy-fix/master/phy-fix.sh
sudo chmod a+x phy-fix.sh
sudo ./phy-fix.sh
```

## How to enter bash environment
refer [this](https://elinux.org/Beagleboard:Terminal_Shells#PuTTy)

