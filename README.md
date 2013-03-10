zendctl.sh-mod
==============

Modification to the default zendctl.sh files that ship with ZendServer 5.6 and ZendServer 6.0 so zendctl will control MySql along with all the other components.

Note: The Mac installer for both ZendServer 5.6 and ZendServer 6.0 doesn't get the ownership right for data/mysql, which will prevent it from starting.

If you see this error:

    Starting MySQL
    ... ERROR! The server quit without updating PID file (/usr/local/zend/mysql/data/myhost.pid)

You should be able to fix it by changing ownership on this dir:

    sudo chown -R zend:wheel /usr/local/zend/mysql/data/mysql