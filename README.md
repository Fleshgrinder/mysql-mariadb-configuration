# mysql
This is my personal MariaDB 5.5 configuration on my Debian “Squeeze” 6 servers.

## Installing MariaDB
I'm using the (switch.ch mirror)[http://www.switch.ch/] in my `sources.list`:

```shell
# Add mirror.switch.ch to the sources.list
echo '# MariaDB 5.5
deb http://mirror.switch.ch/mirror/mariadb/repo/5.5/debian squeeze main
deb-src http://mirror.switch.ch/mirror/mariadb/repo/5.5/debian squeeze main' >> /etc/apt/sources.list
# Fetch the GPG key for MariaDB releases
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
# Update the preferences
echo '# /etc/apt/preferences

Package: *
Pin: Origin mirror.switch.ch
Pin-Priority: 900

Package: *
Pin: release o=Debian,a=stable
Pin-Priority: 500

Package: *
Pin: release o=Debian
Pin-Priority: -1' > /etc/apt/preferences
# Update apt / aptitude
aptitude update
# Create the user for the mysql daemon
adduser --no-create-home --disabled-password --disabled-login mysqld
# Install MariaDB
aptitude install mariadb-server-5.5
```
Have a look at the (MariaDB repository configuration tool)[http://downloads.mariadb.org/MariaDB/repositories/] to find a repository near your server.

## Hugepages
My configuration relies on hugepages support. You can use the configuration without it, the server will work, but it will log an error.
### Activating hugepages
```shell
# Create backup of default system configuration
sysctl -a > ~/sysctl_defaults.conf
# Create configuration for hugepages
echo '
# Activate Hugepages support. Set the number of pages to be used.
# Each page is normally 2MB, so a value of 256 = 512MB.
# Set it to e.g. 512 or higher if you have lots of memory.
vm.nr_hugepages                 = 256

# Set the group number that is allowed to access this memory.
vm.hugetlb_shm_group            = 1004

# Increase the amount of shmem allowed per segment. This depends
# on the total memory our system actually has.
# Value is given in bytes (536870912 = 512MB).
kernel.shmmax                   = 536870912

# Increase total amount of shared memory.
# This should be 50% of available RAM.
# Value is given in bytes (805306368 = 768MB).
kernel.shmall                   = 805306368' > ~/hugepages.conf
# Apply settings
sysctl -p ~/hugepages.conf
```

## Create new init script
In order to be able to use the hugepages you have to raise the ulimit for the mysqld user. I included a shell script which creates that new init script for you.
```shell
# Change to the cloned github repo
cd /path/to/the/cloned/github/repo
# Make the shell script executable
chmod 770 create-mariadb-init-script.sh
# And simply execute it
./create-mariadb-init-script.sh
```
Afterwards you can start/restart/stop your MariaDB server via `/etc/init.d/mariadb`.

## Questions?
Please bare in mind that this is an advanced configuration targeted towards user who have experience in administrating a server. But if you have any questions feel free to open an issue in the wiki of this repo.