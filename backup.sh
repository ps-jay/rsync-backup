#!/bin/bash

set -u

CURL=/usr/bin/curl
RSYNC=/usr/bin/rsync
SSH=/usr/bin/ssh
SSHPASS=/usr/bin/sshpass

EXIT=0

if [[ -n ${KNOCK1} ]] ; then
    ${CURL} -s --connect-timeout 2 http://${HOST}:${KNOCK1}
fi
if [[ -n ${KNOCK1} ]] ; then
    ${CURL} -s --connect-timeout 2 http://${HOST}:${KNOCK2}
fi

for DIR in ${LOCATIONS} ; do
    echo -e "INFO: New backup starting `date`"
    ${RSYNC} -HPax --delete --stats \
          -e "${SSHPASS} -p ${PASSWORD} ${SSH} -p ${PORT} -l ${USERNAME}" \
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
