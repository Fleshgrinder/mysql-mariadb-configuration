#!/bin/sh

# ------------------------------------------------------------------------------
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute
# this software, either in source code form or as a compiled binary, for any
# purpose, commercial or non-commercial, and by any means.
#
# In jurisdictions that recognize copyright laws, the author or authors of this
# software dedicate any and all copyright interest in the software to the
# public domain. We make this dedication for the benefit of the public at large
# and to the detriment of our heirs and successors. We intend this dedication
# to be an overt act of relinquishment in perpetuity of all present and future
# rights to this software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org>
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Completely purge MariaDB including all installed databases.
#
# AUTHOR:    Richard Fussenegger <richard@fussenegger.info>
# COPYRIGHT: 2015 Richard Fussenegger
# LICENSE:   http://unlicense.org/ PD
# ------------------------------------------------------------------------------

user_abort()
{
    printf -- 'Aborting script per user request.\n'
    exit 64
}

readonly QUESTION='This will purge MariaDB from the system, including ALL databases, are you sure?'
readonly DIALOG=$(which dialog whiptail)
if [ "${DIALOG}" = '' ]
then
    REPLY='n'
    printf -- '%s' "${QUESTION}"
    read -r REPLY
    if [ "${REPLY}" != 'y' ] && [ "${REPLY}" != 'Y' ]
        then user_abort
    fi
else
    "${DIALOG}" --title 'Purge MariaDB' --defaultno --yesno "${QUESTION}" 0 0
    if [ ${?} -ne 0 ]
        then user_abort
    fi
fi

printf -- 'Purging MariaDB from the system, including ALL databases!\n'

apt-get --yes -- purge mariadb-server
apt-get --yes -- autoremove
apt-get --yes -- autoclean
rm --recursive --force -- /etc/mysql /var/lib/mysql /var/log/mysql /var/log/mysql.* /etc/init.d/mysql

if [ -e /etc/apt/sources.list.d/mariadb.list ]
    then rm --force -- /etc/apt/sources.list.d/mariadb.list
fi

printf -- 'MariaDB has been completely purged from the system!\n'
