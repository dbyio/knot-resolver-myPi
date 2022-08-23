#! /bin/bash

RUNDIR="/var/run/kresd"

_term() {
  kill -TERM $(jobs -p)
  wait
  exit 0
}

_load_config() {
  # Authorized net blocks (policy.PASS)
  PASS=""
  if [[ -n ${AUTHORIZED_BLOCKS} ]]; then
    for net in ${AUTHORIZED_BLOCKS//,/ }; do
    PASS="${PASS}view:addr(\"${net}\", policy.all(policy.PASS))\\n"
    done
  fi
  sed "s^##AUTHORIZED_BLOCKS##^${PASS}^" /etc/kresd.conf.tmpl > ${RUNDIR}/kresd.conf
}

_load_config

# main process
kresd -c ${RUNDIR}/kresd.conf -n 2>&1 &

# garbage collector
until [ -e ${RUNDIR}/data.mdb ]; do sleep 1; done
kres-cache-gc -c ${RUNDIR} -d 60000 2>&1 &

trap _term SIGTERM SIGINT
wait -n
exit $?
