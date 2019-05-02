#!/bin/bash


# Usage : naiveH.sh <pathToHashFile> <pathToDicFile> <hashTypeCode>
# Paths to program/rules and advanced parameters need to be adjusted in script before use

dateFormat='+%Y_%m_%d_%H_%M_%S'
startDate="$(date $dateFormat)"


#### Parameters ####

# Command line values
HASH_FILE=${1:-"example0.hash"}
DICT_FILE=${2:-"~/myDic.txt"}
HASH_TYPE=${3:-"0"}

# Paths to hashcat files and dictionnary to be used
HASHCAT_BIN=${HASHCAT_BIN:-"$HOME/repos/hashcat-5.1.0/hashcat64.bin"}
HASHCAT_RULEFILES=( "$HOME/repos/hashcat-5.1.0/rules/d3ad0ne.rule" "$HOME/repos/hashcat-5.1.0/rules/rockyou-30000.rule" "$HOME/repos/hashcat-5.1.0/rules/dive.rule" )
HASHCAT_MASKFILES=( "$HOME/repos/hashcat-5.1.0/masks/rockyou-1-60.hcmask" )

# How hard is the GPU going to be hit
WORKLOAD="-w 4"
# Filename for output and pot files
OUTPUT_PREFIX="./result_${startDate}"



#### Script ####

echo -e "\n-----------------------------------------"
echo -e "------------ STARTING naiveH ------------"
echo -e "---------- $startDate ----------"
echo -e "-----------------------------------------"


# LIGHT
echo -e "\n$(date $dateFormat) -- 1/4 -- DICTIONARY ATTACK -------------------------------------------"
#"$HASHCAT_BIN" $WORKLOAD --hash-type "$HASH_TYPE" --attack-mode 0 "$HASH_FILE" "$DICT_FILE" --potfile-path "${OUTPUT_PREFIX}_1.pot" --outfile "${OUTPUT_PREFIX}_1.out"


# MEDIUM
echo -e "\n$(date $dateFormat) -- 2/4 -- DICTIONARY ATTACK WITH RULES --------------------------------"
for currentRuleFile in "${HASHCAT_RULEFILES[$@]}"
do
	suffix="_2_$(basename "$currentRuleFile")"
	echo -e "$(date $dateFormat) --> Using rule file: ${currentRuleFile}"
	#"$HASHCAT_BIN" $WORKLOAD --hash-type "$HASH_TYPE" --attack-mode 0 "$HASH_FILE" "$DICT_FILE" --rules-file "$currentRuleFile" --potfile-path "${OUTPUT_PREFIX}${suffix}.pot" --outfile "${OUTPUT_PREFIX}${suffix}.out"
done


# HEAVY
echo -e "\n$(date $dateFormat) -- 3/4 -- MASK ATTACK (BRUTE-FORCE) -----------------------------------"
for currentMaskFile in "${HASHCAT_MASKFILES[$@]}"
do
	suffix="_3_$(basename "$currentMaskFile")"
	echo -e "$(date $dateFormat) --> Using mask file: ${currentMaskFile}"
	#"$HASHCAT_BIN" $WORKLOAD --hash-type "$HASH_TYPE" --attack-mode 3 "$HASH_FILE" "$currentMaskFile" --potfile-path "${OUTPUT_PREFIX}${suffix}.pot" --outfile "${OUTPUT_PREFIX}${suffix}.out"
done


# This one can take 12+ hours...
echo -e "\n$(date $dateFormat) -- 4/4 -- COMBINATION ATTACK ------------------------------------------"
#"$HASHCAT_BIN" $WORKLOAD --hash-type "$HASH_TYPE" --attack-mode 1 "$HASH_FILE" "$DICT_FILE" "$DICT_FILE" --potfile-path "${OUTPUT_PREFIX}_4.pot" --outfile "${OUTPUT_PREFIX}_4.out"


echo -e "\n-----------------------------------------"
echo -e "-------------- ALL DONE !! --------------"
echo -e "-----------------------------------------"

