#!/bin/bash
#

JB_EN="false";
MYSQL_EN="false";
if [ -f /etc/zce.rc ];then
    . /etc/zce.rc
else
    echo "/etc/zce.rc doesn't exist!"
    exit 1;
fi
if [ -f $ZCE_PREFIX/bin/shell_functions.rc ];then
    . $ZCE_PREFIX/bin/shell_functions.rc
else
    echo "$ZCE_PREFIX/bin/shell_functions.rc doesn't exist!"
    exit 1;
fi
check_root_privileges

usage()
{
    $ECHO_CMD "Usage: $0 <action>"
    $ECHO_CMD ""
    $ECHO_CMD "	start               Start all $PRODUCT_NAME daemons"
    $ECHO_CMD "	start-apache	    Start Apache only"
    $MYSQL_EN && $ECHO_CMD "	start-mysql	    Start MySQL only"
    $JB_EN && $ECHO_CMD "	start-jb	    Start Java Bridge only"
    $ECHO_CMD "	start-lighttpd      Start lighttpd only\n"
    $ECHO_CMD "	stop                Stop all $PRODUCT_NAME daemons"
    $ECHO_CMD "	stop-apache         Stop Apache only"
    $MYSQL_EN && $ECHO_CMD "	stop-mysql          Stop MySQL only"
    $JB_EN && $ECHO_CMD "	stop-jb             Stop Java Bridge only"
    $ECHO_CMD "	stop-lighttpd       Stop lighttpd only\n"
    $ECHO_CMD "	restart             Restart all $PRODUCT_NAME daemons"
    $ECHO_CMD "	restart-apache      Restart Apache only"
    $MYSQL_EN && $ECHO_CMD "	restart-mysql	    Restart MySQL only"
    $JB_EN && $ECHO_CMD "	restart-jb	    Restart Java Bridge only"
    $ECHO_CMD "	restart-lighttpd    Restart lighttpd only\n"
    $ECHO_CMD "	setup-jb            Setup Java bridge"
    $ECHO_CMD "	version             Print $PRODUCT_NAME version"
    $ECHO_CMD "	status              Get $PRODUCT_NAME status\n"
}
case $1 in
	"start")
		$ECHO_CMD "Starting $PRODUCT_NAME $PRODUCT_VERSION ..\n"
		$0 start-zdd %
		$0 start-monitor-node
		$0 start-apache %
		$0 start-lighttpd %
		$JB_EN && $0 start-jb %
		$0 start-jqd %
		$ECHO_CMD "\n$PRODUCT_NAME started..."
		;;

	"restart")
		$0 restart-zdd
		$0 restart-monitor-node
		$0 restart-apache
		$0 restart-lighttpd
		$0 restart-jb
		$0 restart-jqd
		;;

	"start-apache")
                if [ -x $ZCE_PREFIX/bin/apachectl ];then
                    $ZCE_PREFIX/bin/apachectl start
                fi
		;;

	"start-mysql")
		if $MYSQL_EN; then
                    $ZCE_PREFIX/mysql/bin/mysql.server start
                fi
		;;

	"start-lighttpd")
                $ZCE_PREFIX/bin/lighttpdctl.sh start
		;;
		
	"start-jb")
		if $JB_EN;then 
                    $ZCE_PREFIX/bin/java_bridge.sh start
		fi
		;;
	"start-monitor-node")
                $ZCE_PREFIX/bin/monitor-node.sh start
		;;
	"start-zdd")
                $ZCE_PREFIX/bin/zdd.sh start
		;;
	"start-jqd")
                $ZCE_PREFIX/bin/jqd.sh start
		;;
	"stop")
		$ECHO_CMD "Stopping $PRODUCT_NAME $PRODUCT_VERSION ..\n"

		$0 stop-apache %
		sleep 2
		$ZCE_PREFIX/bin/clean_semaphores.sh
	        $0 stop-lighttpd %
		$JB_EN && $0 stop-jb %
			$0 stop-jqd %
			$0 stop-zdd %
			$0 stop-monitor-node %
		$ECHO_CMD "\n$PRODUCT_NAME stopped."
		;;

	"stop-apache")
                $ZCE_PREFIX/bin/apachectl stop
		# Clean datacache SHM files (JIRA issue ZSRV-ZSRV-4945)
		for DIR in $ZCE_PREFIX/tmp /tmp; do
			rm -f $DIR/zshm_ZShmStorage_*
		done
		;;
	"stop-monitor-node")
                $ZCE_PREFIX/bin/monitor-node.sh stop
		;;

	"stop-zdd")
                $ZCE_PREFIX/bin/zdd.sh stop
		;;
	"stop-jqd")
                $ZCE_PREFIX/bin/jqd.sh stop
		;;


	"stop-mysql")
		if $MYSQL_EN; then
                    $ZCE_PREFIX/mysql/bin/mysql.server stop
                fi
		;;

	"stop-lighttpd")
                $ZCE_PREFIX/bin/lighttpdctl.sh stop
		;;

	"restart-lighttpd")
                $ZCE_PREFIX/bin/lighttpdctl.sh restart
		;;


	"stop-jb")
		if $JB_EN;then 
                    $ZCE_PREFIX/bin/java_bridge.sh stop
		fi
		;;

	"restart-jb")
		if $JB_EN;then 
                    $ZCE_PREFIX/bin/java_bridge.sh restart
		fi
		;;

	"setup-jb")
                if [ -x $ZCE_PREFIX/bin/setup_jb.sh ];then
                    $ZCE_PREFIX/bin/setup_jb.sh
                else
                    echo "Java bridge is not installed, please install the java-bridge-zend-$DIST package."
                fi
		;;
	"restart-monitor-node")
        $0 stop-monitor-node
		sleep 2
		$0 start-monitor-node
		;;
	"restart-apache")
		$0 stop-apache
		sleep 2
		$0 start-apache
		;;
	"restart-zdd")
		$0 stop-zdd
		sleep 2
		$0 start-zdd
		;;
	"restart-jqd")
		$0 stop-jqd
		sleep 2
		$0 start-jqd
		;;
	"restart-mysql")
		if $MYSQL_EN;then
			$0 stop-mysql
			sleep 2
			$0 start-mysql
		fi
		;;

	"restart")
		$0 stop
		sleep 2 
		$0 start
		;;

	"status")
                $ZCE_PREFIX/bin/apachectl status
                $ZCE_PREFIX/bin/lighttpdctl.sh status
				$ZCE_PREFIX/bin/monitor-node.sh status
                $ZCE_PREFIX/bin/jqd.sh status
                $ZCE_PREFIX/bin/zdd.sh status
		if $JB_EN;then 
                    $ZCE_PREFIX/bin/java_bridge.sh status
		fi
		;;


        "version")
                $ECHO_CMD "$PRODUCT_NAME version: $PRODUCT_VERSION"
                ;;

	*)	
                usage
                exit 1
		;;
esac
