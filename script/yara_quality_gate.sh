#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${BASE_SHA:-}" || -z "${HEAD_SHA:-}" ]]; then
  echo "BASE_SHA and HEAD_SHA are required."
  exit 2
fi

changed_files="$(git diff --name-only --diff-filter=ACMR "$BASE_SHA" "$HEAD_SHA")"

if [[ -z "$changed_files" ]]; then
  echo "No changed files detected."
  exit 0
fi

echo "Evaluating changed files; source content is never printed."

blocked_name_pattern='(^|/)(\.env($|\.)|credentials\.yml\.enc$|master\.key$|id_rsa$|id_ed25519$|.*\.pem$|.*\.p12$|.*\.pfx$)'
if grep -Eq "$blocked_name_pattern" <<< "$changed_files"; then
  echo "Blocked: a credential or environment file was added or modified."
  exit 1
fi

diff_content="$(git -c core.quotePath=true diff --no-ext-diff --no-textconv --unified=0 "$BASE_SHA" "$HEAD_SHA" -- .)"
added_lines="$(sed '/^+++ /d; /^+/!d' <<< "$diff_content")"

secret_pattern='(BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|AWS_SECRET_ACCESS_KEY[[:space:]]*=|SECRET_KEY_BASE[[:space:]]*=|DATABASE_URL[[:space:]]*=|REDIS_URL[[:space:]]*=|IXC_.*(TOKEN|PASSWORD|SECRET)[[:space:]]*=|EVOLUTION_.*(TOKEN|PASSWORD|SECRET)[[:space:]]*=)'
if grep -Eiq "$secret_pattern" <<< "$added_lines"; then
  echo "Blocked: a possible secret or production connection value was introduced."
  exit 1
fi

direct_yara_access_pattern='(YARA_''DATABASE_URL|YARA_''REDIS_URL|IXC_''DATABASE|ACS_''DATABASE)'
if grep -Eiq "$direct_yara_access_pattern" <<< "$added_lines"; then
  echo "Blocked: direct access to an internal YARA datastore or provider was introduced."
  exit 1
fi

if grep -Eq '^(db/migrate/|config/initializers/|config/routes\.rb$|\.github/|docker/|deployment/|script/yara_quality_gate\.sh$|yara-protected-paths\.txt$)' <<< "$changed_files"; then
  echo "Critical paths changed. CODEOWNERS approval must be enforced by the repository Ruleset."
fi

echo "YARA Policy Check passed."
