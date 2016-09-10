# CONSTANTS
readonly PROJECT_NAME="nodetalking"
readonly PROGNAME="$( basename $0 )"
readonly LOG_FILE=""
readonly NC_BIN_NAME="netcat"
readonly SCRIPT_DEPENDENCIES=( "${NC_BIN_NAME}" )
readonly PID_TIMEOUT=600
readonly LOCK_FILE="${HOME_DIR}/.lck"
readonly HOSTS_FILE="${HOME_DIR}/hosts.txt"
readonly CHECK_TIMEOUT=5