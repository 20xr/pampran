set -o errexit -o pipefail -o nounset
# set -o xtrace

read_default () {
  local INPUT
  read -p "$1: ($2) " INPUT
  echo ${INPUT:-$2}
}

STACK_NAME=$(read_default "Stack name" "test")
DOMAIN_NAME=$(read_default "Domain name" "")
AMI_ID=$(read_default "AMI id" "ami-a4827dc9")
SSH_KEYNAME=$(read_default "SSH key" "")

aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file:///$PWD/stack.json \
  --on-failure DO_NOTHING \
  --capabilities CAPABILITY_IAM \
  --parameters \
  ParameterKey=DomainName,ParameterValue=${DOMAIN_NAME} \
  ParameterKey=SshKeyName,ParameterValue=${SSH_KEYNAME} \
  ParameterKey=ImageId,ParameterValue=${AMI_ID}
