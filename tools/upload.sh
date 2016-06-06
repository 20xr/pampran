#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

# first argument must be S3 bucket name
S3BUCKET=$1

VERSION_ID=`date +"%Y-%m-%d-%H%M%S"`
# This creates the tar file based on the npm package.json file
TARFILE=`npm pack`
# The next 4 lines trim off everything after the last dash (-)
IFS='-' read -ra TARFILE_SPLIT <<< "${TARFILE}"
unset TARFILE_SPLIT[${#TARFILE_SPLIT[@]}-1]
function join { local IFS="$1"; shift; echo "$*"; }
PACKAGE_NAME=`join - "${TARFILE_SPLIT[@]}"`

cat <<EOF > version
${VERSION_ID}
${TARFILE}
${PACKAGE_NAME}
EOF

# important to copy the tarball first before updating the version file
aws s3 cp ${TARFILE} s3://${S3BUCKET}
aws s3 cp version s3://${S3BUCKET}

#rm version
rm ${TARFILE}
