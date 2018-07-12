#!/bin/bash

set -u

RSYNC=/bin/rsync

EXIT=0

if [[ -n ${KNOCK1} ]] ; then
    curl -s --connect-timeout 2 http://${HOST}:${KNOCK1}
fi
if [[ -n ${KNOCK1} ]] ; then
    curl -s --connect-timeout 2 http://${HOST}:${KNOCK2}
fi

for DIR in ${LOCATIONS} ; do
    echo -e "INFO: New backup starting `date`"
    rsync -HPax --delete --stats \
          -e "sshpass -p ${PASSWORD} ssh -p ${PORT} -l ${USERNAME}" \
          ${DIR} \
          ${HOST}::${TARGET}${DIR}

    RSYNC_EXIT=${?}
    if [[ ${RSYNC_EXIT} -ne 0 ]] ; then
        echo "ERROR: rsync exited non-zero for ${DIR}"
        EXIT=${RSYNC_EXIT}
    fi

    echo -e "\n"
done

exit ${EXIT}
