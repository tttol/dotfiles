#!/bin/zsh
set -euo pipefail

if (( $# == 0 )); then
  print -u2 "Usage: $0 <aws-command> [arguments...]"
  exit 64
fi

exec zsh -lic '
unset AWS_PROFILE
as
switch_status=$?
if (( switch_status != 0 )); then
  exit $switch_status
fi
if [[ -z ${AWS_PROFILE:-} ]]; then
  print -u2 "No AWS profile selected."
  exit 0
fi
exec "$@"
' aws-account-investigation "$@"
