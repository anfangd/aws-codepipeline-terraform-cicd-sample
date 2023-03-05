#!/bin/bash

# Accept Command Line Arguments
working_dir=$1
SKIPVALIDATIONFAILURE=$2
tfValidate=$3
tfLint=$4
tfTfsec=$5
# -----------------------------

echo "### VALIDATION Overview ###"
echo "-------------------------"
echo "Skip Validation Errors on Failure : ${SKIPVALIDATIONFAILURE}"
echo "Terraform Validate : ${tfValidate}"
echo "Terraform tflint   : ${tfLint}"
echo "Terraform tfsec    : ${tfTfsec}"
echo "------------------------"
cd ${working_dir}
terraform init
if (( ${tfValidate} == "Y"))
then
    echo "## VALIDATION : Validating Terraform code ..."
    terraform validate
fi
tfValidateOutput=$?

if (( ${tfLint} == "Y"))
then
    echo "## VALIDATION : Lint Terraform code ..."
    tflint
fi
tfLintOutput=$?

if (( ${tfTfsec} == "Y"))
then
    echo "## VALIDATION : Running tfsec ..."
    #tfsec .
    tfsec ./ --format junit --out tfsec-junit.xml
fi
tfTfsecOutput=$?

echo "## VALIDATION Summary ##"
echo "------------------------"
echo "Terraform Validate : ${tfValidateOutput}"
echo "Terraform tflint   : ${tfLintOutput}"
echo "Terraform tfsec    : ${tfTfsecOutput}"
echo "------------------------"

if (( ${SKIPVALIDATIONFAILURE} == "Y" ))
then
  #if SKIPVALIDATIONFAILURE is set as Y, then validation failures are skipped during execution
  echo "## VALIDATION : Skipping validation failure checks..."
elif (( $tfValidateOutput == 0 && $tfLintOutput == 0 && $tfTfsecOutput == 0 ))
then
  echo "## VALIDATION : Checks Passed!!!"
else
  # When validation checks fails, build process is halted.
  echo "## ERROR : Validation Failed"
  exit 1;
fi
