# usage: prints script usage
usage() {
 
  echo
  echo "Usage: ${PROGNAME} <options>"
  echo
  echo "OPTIONS"
  echo " * No options have been defined"
}

nt::abrt() {

  nt::unlock
  bp::abrt $@
}


## Functions required
nt::check_lock() {
  
  if [ -f "${LOCK_FILE}" ]; then
    
    local time_now="$( date +%s )"
    local last_lock_time="$( grep locktime "${LOCK_FILE}" | cut -d= -f2 )"

    if [ $((time_now - last_lock_time)) -gt ${PID_TIMEOUT} ]; then
      nt::abrt "${PROJECT_NAME} is currently locked, but exceeds the lock timeout of ${PID_TIMEOUT} seconds. Consider deleting stale lock file manually."
    else
      nt::abrt "${PROJECT_NAME} is currently locked"
    fi
  else
    return 0
  fi

}

nt::lock() {
  
  touch "${LOCK_FILE}"
  local date_now="$( date +%s )"
  echo "locktime=${date_now}" > "${LOCK_FILE}"
  
}

nt::unlock() {
  rm "${LOCK_FILE}"
}


nt::setup() {
  [ ! -f "${HOSTS_FILE}" ] && touch "${HOSTS_FILE}"
}

nt::check_hosts_file() {

  local host_total_entries="$( grep -v '^#' "${HOSTS_FILE}" | wc -l | awk '{ print $1 }' )"
  
  if [ ${host_total_entries} -eq 0 ]; then
    
    echo "WARNING: No hosts specified in ${HOSTS_FILE}"
    nt::unlock
    exit 1

  fi

}

nt::check_port() {

  local req_args=2 ; [ $# -ne ${req_args} ] && nt::abrt "nt::check_port - invalid args received. Needed ${req_args}, got $#"

  local host="$1"
  local port="$2"

  [ -n "$( echo "${port}" | tr -d [:digit:] )" ] && nt::abrt "nt::check_port: ${port} is not a valid port"

  if ncat -w ${CHECK_TIMEOUT} "${host}" ${port} < /dev/null >/dev/null 2>&1 ; then
    return 0
  else
    return 1
  fi

}

nt::check_hosts() {

  local hosts=( $( grep -v '^#' "${HOSTS_FILE}" ) )
  local open_ports=""

  for host_data in "${hosts[@]}" ; do
  
    local this_host="$( echo "${host_data}" | cut -d, -f1 )"
    local this_host_ports=( $( echo "${host_data}" | sed "s/${this_host}.//g" | tr ',' "\n" ) )

    for this_host_port in "${this_host_ports[@]}" ; do
    
      #echo -n "Checking port ${this_host_port} on ${this_host}: " 
    
      if nt::check_port ${this_host} ${this_host_port} ; then

        [ -n "${open_ports}" ] && open_ports="${open_ports} ${this_host}:${this_host_port}"        
        [ -z "${open_ports}" ] && open_ports="${this_host}:${this_host_port}"

      fi

    done

  done

  if [ -n "${open_ports}" ]; then
    
    echo "CRITICAL: Ports OPEN: ${open_ports}" 
    nt::unlock
    exit 2

  else

    echo "OK: No open ports found"
    nt::unlock
    exit 0
  fi
}