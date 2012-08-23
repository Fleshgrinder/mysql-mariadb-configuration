#!/bin/bash

# ----------------------------------------------------------------------
# Create new init script for MariaDB after hugepages have been activated.
# This init script raises the limit for shared memory to unlimited.
# Otherwise the MariaDB process is not able to lock the hugepages for
# itself. After raising the limit the normal init script is called. We
# create a separate init script to not break the normal apt / aptitude
# upgrade process of MariaDB (which includes the normal mysql init
# script)!
#
# ----------------------------------------------------------------------
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
# 
# Copyright (c) 2012 Richard Fussenegger <richard@fussenegger.info>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#
# ----------------------------------------------------------------------

# Tell the user that we are goin to create a new init script
echo 'Creating new MariaDB inti script at /etc/init.d/mariadb'

# Create the actual init script
echo '#!/bin/bash
#
### BEGIN INIT INFO
# Provides:          MariaDB
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Should-Start:      $network $named $time
# Should-Stop:       $network $named $time
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start and stop the MariaDB database server daemon
# Description:       Controls the main MariaDB database server daemon "mysqld"
#                    and its wrapper script "mysqld_safe".
### END INIT INFO

ulimit -l unlimited
sh /etc/init.d/mysql "${1:-'\'''\''}"' > /etc/init.d/mariadb

# Change permissions so it is executable
chmod 770 /etc/init.d/mariadb

# Remove the old init script from the system startup
update-rc.d -f mysql remove

# Add our new init script to the system startup
update-rc.d mariadb defaults

# Tell the user that we are done
echo 'New init script created and added to system startup. DONE!'