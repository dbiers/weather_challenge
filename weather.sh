#!/bin/bash
# Author: david@dbiers.me
# Veeva coding challenege

# Predefined Vars
MY_BASE=$(basename $0)
MY_DIR=$( readlink -f $(dirname $0) )

# Include config
if [[ -f "${MY_DIR}/api.conf" ]]
then
    # Including
    source ${MY_DIR}/api.conf
else
    echo "Config file does not exist (${MY_DIR}/api.conf)"
    exit 2
fi

# Usage
func_usage() {
    cat << EOF

    ${MY_DIR}/${MY_BASE} -z <ZIPCODE> [-h][-d]

    -z      REQUIRED: ZIP Code for weather request
    -d      Debug mode (set -x)
    -h      Print this help menu

EOF
}

# Options and Args
while getopts hz:d opt
do
    case $opt in
	h)
	    func_usage
	    exit 0
	    ;;
	d)
	    echo "Debug Enabled"
	    set -x
	    ;;
	z)
	    ZIPCODE="${OPTARG}"
	    ;;
	*)
	    echo "Unknown Arg/Option"
	    exit 2
	    ;;
    esac
done

# Is ZIP set?
if [[ -z ${ZIPCODE} ]]
then
    echo "ZIP code not set."
    func_usage
    exit 2
fi

# Get ZIP, convert to lat/lon
#LATLON="$(curl -X GET "http://api.openweathermap.org/geo/1.0/zip?zip=${ZIPCODE}&appid=${APIKEY}" -s)"
#LAT="$(echo ${LATLON} | jq '.lat' -r)"
#LON="$(echo ${LATLON} | jq '.lon' -r)"

# Get Weather
WEATHERDATA="$(curl -X GET "https://api.openweathermap.org/data/2.5/forecast?zip=${ZIPCODE}&appid=${APIKEY}&units=imperial" -s)"

# Let your migraine begin
JSON_WEATHER="$(echo ${WEATHERDATA} | jq '[.list[] | del(.dt) | (.dt_txt |= sub(" .*"; "")) | { date:.dt_txt, temp:.main.temp, rain:((.rain | add) ? // 0) }] | group_by(.date)[]? | { date:.[0].date, high: (max_by(.temp) | .temp), low: (min_by(.temp) | .temp), total_rain: (map(.rain) | add) }' -c)"

echo -e "Date\t\tTempHi/Low\t\tPrecipitation"
echo -e "====\t\t==========\t\t============="

echo ${JSON_WEATHER} | jq '.' -c | while read line
do
    DATE="$(echo ${line} | jq '.date' -r)"
    TEMP_HI="$(echo ${line} | jq '.high' -r)"
    TEMP_LO="$(echo ${line} | jq '.low' -r)"
    TOTRAIN="$(echo ${line} | jq '.total_rain' -r)"
echo -e "${DATE}\t${TEMP_HI}/${TEMP_LO}\t\t${TOTRAIN}mm"
done
