zendctl.sh-mod
==============

# Versions Affected

* ZendServer 5.6
* ZendServer 6.0

# Update control scripts to include MySQL

By default, installers for affected versions will not add control of MySql start/stop/restarts along with all the other server components. There are two places where the Mac installer puts zendctl.sh scripts. The two versions differ slightly, so make sure you put each one in its respective path as shown in this repo.

See [this diff](https://github.com/jeremiahsmall/zendctl.sh-mod/commit/cd4c71a91b15bcc58c8223070493ecbfb31253ba) if you're interested in the details of this mod.

# Fix MySQL ownership problems

The Mac installer for affected versions doesn't get the ownership right for data/mysql, which will prevent it from starting.

If you see an error similar to this:

    Starting MySQL
    ... ERROR! The server quit without updating PID file (/usr/local/zend/mysql/data/myhost.pid)

You should be able to fix it by changing ownership on this directory:

    sudo chown -R zend:wheel /usr/local/zend/mysql/data/mysql