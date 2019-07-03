#!/bin/bash
INPUT_DUMPS_DIR=/opt/2019/07/02
POSTGIS_RESTORE=/usr/share/postgresql/9.5/contrib/postgis-2.3/postgis_restore.pl

for dump_file in `ls $INPUT_DUMPS_DIR/*.compressed`
#for dump_file in `ls $INPUT_DUMPS_DIR/-SOS_ARC.compressed`
do
    db_name=$(basename $dump_file | cut -d '.' -f1 | cut -d '-' -f2)
    echo "creating $db_name" &>> /scripts/restore.log
    createdb -U postgres $db_name &>> /scripts/restore.log
    echo "adding postgis extension to $db_name" &>> /scripts/restore.log
    psql -U postgres -d $db_name -c "create EXTENSION postgis;" &>> /scripts/restore.log
    echo "restoring $db_name" &>> /scripts/restore.log &>> /scripts/restore.log
    perl $POSTGIS_RESTORE $dump_file | psql -U postgres -d $db_name &>> /scripts/restore.log    
done


#    1  find . | grep postgis_restore
#    2  cd /usr/share/postgresql/9.5/contrib/postgis-2.3/
#    3  ls
#    4  ls /opt/2019/07/02/-SOS_ARC.compressed
#    5  creatdb -U postgres SOS_ARC
#    6  createdb -U postgres SOS_ARC
#    7  psql -U postgres -d SOS_ARC
#    8   sql$> create EXTENSION postgis.
#    9  perl postgis_restore.pl /opt/2019/07/02/-SOS_ARC.compressed | psql -U postgres -d SOS_ARC
