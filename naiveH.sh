#!/bin/bash


# Usage : naiveH.sh <pathToHashFile> <pathToDicFile> <hashTypeCode>
# Paths to program/rules and advanced parameters need to be adjusted in script before use



#### Parameters ####

# Command line values
HASH_FILE=${1:"example0.hash"}
DICTFILE=${2:-"~/myDic.txt"}
HASH_TYPE=${3:-"0"}

# Paths to hashcat files and dictionnary to be used
HASHCAT_BIN=${HASHCAT_BIN:-"/usr/local/bin/hashcat"}
HASHCAT_RULEFILES=( "d3ad0ne.rule" "rockyou-30000.rule" "dive.rule" )
HASHCAT_MASKFILES=( "rockyou-1-60.hcmask" )

# How hard is the GPU going to be hit
WORKLOAD="-w 4"
# Filename for output and pot files
OUTPUT_PREFIX="./result"



#### Script ####

dateFormat='+%Y_%m_%d_%H_%M_%S'
startDate="$(date $dateFormat)"

echo -e "-----------------------------------------"
echo -e "------------ STARTING naiveH ------------"
echo -e "---------- $startDate ----------"
echo -e "-----------------------------------------"


# LIGHT
echo -e "\n$(date $dateFormat) -- DICTIONARY ATTACK -------------------------------------------"
"$HASHCAT_BIN" "$WORKLOAD" --hash-type "$HASH_TYPE" --attack-mode 0 "$HASH_FILE" "$DICTFILE" --potfile-path "${OUTPUT_PREFIX}.pot" --outfile "${OUTPUT_PREFIX}.out"


# MEDIUM
echo -e "\n$(date $dateFormat) -- DICTIONARY ATTACK WITH RULES --------------------------------"
for currentRuleFile in "${HASHCAT_RULEFILES[$@]}"
do
	echo -e "$(date $dateFormat) --> Using rule file: ${currentRuleFile}"
	"$HASHCAT_BIN" "$WORKLOAD" --hash-type "$HASH_TYPE" --attack-mode 0 "$HASH_FILE" "$DICTFILE" --rules-file "$currentRuleFile" --potfile-path "$POT_FILENAME" --outfile "${OUTPUT_PREFIX}.out"
done


# HEAVY
echo -e "\n$(date $dateFormat) -- MASK ATTACK (BRUTE-FORCE) -----------------------------------"
for currentMaskFile in "${HASHCAT_MASKFILES[$@]}"
do
	echo -e "$(date $dateFormat) --> Using mask file: ${currentMaskFile}"
	"$HASHCAT_BIN" "$WORKLOAD" --hash-type "$HASH_TYPE" --attack-mode 3 "$HASH_FILE" "$currentMaskFile" --potfile-path "$POT_FILENAME" --outfile "${OUTPUT_PREFIX}.out"
done


# This one can take 12+ hours...
echo -e "\n$(date $dateFormat) -- COMBINATION ATTACK ------------------------------------------"
"$HASHCAT_BIN" "$WORKLOAD" --hash-type "$HASH_TYPE" --attack-mode 1 "$HASH_FILE" "$DICTFILE" "$DICTFILE" --potfile-path "$POT_FILENAME" --outfile "${OUTPUT_PREFIX}.out"


echo -e "\n-----------------------------------------"
echo -e "-------------- ALL DONE !! --------------"
echo -e "-----------------------------------------"

