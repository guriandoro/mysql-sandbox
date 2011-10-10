#!_BINBASH_
__LICENSE__
#-----------------------------------------
SBDIR="_HOME_DIR_/_SANDBOXDIR_"
. "$SBDIR/sandbox_env"
#-----------------------------------------

TIMEOUT=20
if [ -f $PIDFILE ]
then
    echo "sandbox server already started (found pid file $PIDFILE)"
else
    CURDIR=`pwd`
    cd $BASEDIR
    if [ "$SBDEBUG" = "" ]
    then
        eval "$MYSQLD_SAFE $MYDEF $@ > $MYOUTPUT $MYREDIR $MYBG"
        if [ "$MYFG" != "" ]
        then
            exit
        fi
    else
        $MYSQLD_SAFE $MYDEF $@ > "$SBDIR/start.log" 2>&1 &
    fi
    cd $CURDIR
    ATTEMPTS=1
    while [ ! -f $PIDFILE ] 
    do
        ATTEMPTS=$(( $ATTEMPTS + 1 ))
        echo -n "."
        if [ $ATTEMPTS = $TIMEOUT ]
        then
            break
        fi
        sleep 1
    done
fi

if [ -f $PIDFILE ]
then
    echo " sandbox server started"
else
    echo " sandbox server not started yet"
fi
