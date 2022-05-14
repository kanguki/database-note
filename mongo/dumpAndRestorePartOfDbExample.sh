#
#Dump data from a mongo container from one server and restore in one container on another server
#
TIME_FORMAT=^[0-9]{4}-[0-9]{2}-[0-9]{2}$ #yyyy-mm-dd
if [[ -z $1 || -z $2  || ! $1 =~ $TIME_FORMAT || ! $2 =~ $TIME_FORMAT ]] 
then
	echo "error: need to provide FROM_DATE and TO_DATE via 2 arguments respectively in format yyyy-mm-dd"
	echo "for e.g."
        echo "$0 2022-05-19 2022-05-20"
	exit 1
fi

#---------------------------------------------------------------MODIFY THIS BLOCK AS YOU NEED----------------------------------------------------------------#
# SRC and DST use the same vpn tunnel, if they're different, re-declare, and modify helper vars/funcs below this block
TUNNEL_ADDR=""
SSH_USER=""
SSH_PASS=""

SRC_SSH_PORT=""
SRC_MONGO_DB=""
SRC_MONGO_COLLECTION=""
SRC_MONGO_DB_USER="" 
SRC_MONGO_DB_PASS="" 

DST_SSH_PORT="" 
DST_MONGO_DB=""
DST_MONGO_COLLECTION=""
DST_MONGO_DB_USER="" 
DST_MONGO_DB_PASS="" 
BASE_DIR=""
#---------------------END OF MODIFIABLE BLOCK. EXCEPT FOR TURNING ON FUNCTIONS AT THE END OF FILE, YOU SHOULDN'T TOUCH THE REST------------------------------#

FROM_DATE=$1
TO_DATE=$2
OUT_FILE=dumpy/${DST_MONGO_DB}_${DST_MONGO_COLLECTION}_${FROM_DATE}_${TO_DATE}.archive

#Short variables
X="${SSH_USER}@${TUNNEL_ADDR}" #Isn't it too long to type it out
OF="${BASE_DIR}${OUT_FILE}" #path of dump file on server

#Helper functions
_doInSrc() {
	sshpass -p "$SSH_PASS" ssh -o ConnectTimeout=10 -p $SRC_SSH_PORT $X "$@"
}
_doOnDst() {
	sshpass -p "$SSH_PASS" ssh -o ConnectTimeout=10 -p $DST_SSH_PORT $X "$@"
}
_scpass() {
	sshpass -p "$SSH_PASS" scp  "$@"
}

#Function declarations
SRC_MONGO= #SRC_MONGO_CONTAINER_NAME
dumpDataFromSrc() {
	echo "dumpDataFromSrc"
	if [[ -z $SRC_MONGO ]]; then SRC_MONGO=`_doInSrc "docker ps --format '{{ .Names }}' | grep mong"`;fi
	#if there's space in this query, it'll fail
	_query="\{date:\{\\\$gte:\{\\\"\\\$date\\\":\\\"${FROM_DATE}T00:00:00.001Z\\\"\},\\\$lte:\{\\\"\\\$date\\\":\\\"${TO_DATE}T23:59:59.000Z\\\"\}\}\}" 
	_container=$SRC_MONGO; _db=$SRC_MONGO_DB; _col=$SRC_MONGO_COLLECTION; _user=$SRC_MONGO_DB_USER; _pw=$SRC_MONGO_DB_PASS
	#_doInSrc "docker exec $_container echo $_query" #debug

	_doInSrc "docker exec $_container mkdir -p dumpy && 
		docker exec $_container mongodump -u $_user -p $_pw --authenticationDatabase=$_db --db $_db --collection=$_col --query=$_query --gzip --archive=${OUT_FILE} && 
		mkdir -p dumpy && 
		docker cp $_container:/${OUT_FILE} $OF"
}

copyDataToLocal() {
	echo "copyDataToLocal"
	mkdir -p dumpy
	_scpass -P $SRC_SSH_PORT $X:$OF ${OUT_FILE}
}

DST_MONGO= #DST_MONGO_CONTAINER_NAME
copyDataToDstServer() {
	echo "copyDataToDstServer"
	if [[ -z $DST_MONGO ]]; then DST_MONGO=`_doOnDst "docker ps --format '{{ .Names }}' | grep mong"`; fi
	_doOnDst "mkdir -p dumpy"
	_scpass -P $DST_SSH_PORT ${OUT_FILE} $X:$OF 

	_doOnDst "docker exec $DST_MONGO mkdir -p dumpy && docker cp $OF $DST_MONGO:/${OUT_FILE}"
}

removeOldDataAndRestore() {
	echo "removeOldDataAndRestore"
	if [[ -z $DST_MONGO ]]; then DST_MONGO=`_doOnDst "docker ps --format '{{ .Names }}' | grep mong"`; fi
	_query="db.${DST_MONGO_COLLECTION}.remove({date: {\$gte: ISODate(\"${FROM_DATE}T00:00:00.001Z\"), \$lte: ISODate(\"${TO_DATE}T23:59:59.000Z\")}});"
	_container=$DST_MONGO; _db=$DST_MONGO_DB; _col=$DST_MONGO_COLLECTION; _user=$DST_MONGO_DB_USER; _pw=$DST_MONGO_DB_PASS

	_doOnDst "docker exec $_container mongo -u $_user -p $_pw --eval '$_query' $_db && 
		docker exec $_container mongorestore -u $_user -p $_pw --gzip --db $_db --archive=${OUT_FILE}" 
}

clearAllData() {
	echo "clearAllData"
	rm $OUT_FILE
	if [[ -z $SRC_MONGO ]]; then SRC_MONGO=`_doInSrc "docker ps --format '{{ .Names }}' | grep mong"`;fi
	_doInSrc "rm $OF && docker exec $SRC_MONGO rm /${OUT_FILE}"
	if [[ -z $DST_MONGO ]]; then DST_MONGO=`_doOnDst "docker ps --format '{{ .Names }}' | grep mong"`; fi
	_doOnDst "rm $OF && docker exec $DST_MONGO rm /${OUT_FILE}"
}

runAndCalculateTimeSpent() {
	secStart=`date +%s`
	$@
	secEnd=`date +%s`
	echo "took $(( $secEnd - $secStart )) seconds"
}
#Start from here
echo "remove comments to run task"
#runAndCalculateTimeSpent dumpDataFromSrc
#runAndCalculateTimeSpent copyDataToLocal
#runAndCalculateTimeSpent copyDataToDstServer
#runAndCalculateTimeSpent removeOldDataAndRestore
#runAndCalculateTimeSpent clearAllData
