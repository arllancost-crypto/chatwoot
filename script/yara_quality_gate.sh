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

echo "Files evaluated by YARA Policy Gate:"
printf '%s\n' "$changed_files"

blocked_name_pattern='(^|/)(\.env($|\.)|credentials\.yml\.enc$|master\.key$|id_rsa$|id_ed25519$|.*\.pem$|.*\.p12$|.*\.pfx$)'
if printf '%s\n' "$changed_files" | grep -E "$blocked_name_pattern"; then
  echo "Blocked: a credential or environment file was added or modified."
  exit 1
fi

added_lines="$(git diff --unified=0 "$BASE_SHA" "$HEAD_SHA" -- . ':!spec/fixtures/**' ':!test/fixtures/**' ':!script/yara_quality_gate.sh' | grep '^+' | grep -v '^+++' || true)"

secret_pattern='(BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|AWS_SECRET_ACCESS_KEY[[:space:]]*=|SECRET_KEY_BASE[[:space:]]*=|DATABASE_URL[[:space:]]*=|REDIS_URL[[:space:]]*=|IXC_.*(TOKEN|PASSWORD|SECRET)[[:space:]]*=|EVOLUTION_.*(TOKEN|PASSWORD|SECRET)[[:space:]]*=)'
if printf '%s\n' "$added_lines" | grep -Ei "$secret_pattern"; then
  echo "Blocked: a possible secret or production connection value was introduced."
  exit 1
fi

direct_yara_access_pattern='(YARA_DATABASE_URL|YARA_REDIS_URL|IXC_DATABASE|ACS_DATABASE)'
if printf '%s\n' "$added_lines" | grep -Ei "$direct_yara_access_pattern"; then
  echo "Blocked: direct access to an internal YARA datastore or provider was introduced."
  exit 1
fi

if printf '%s\n' "$changed_files" | grep -Eq '^(db/migrate/|config/initializers/|config/routes\.rb$|\.github/|docker/|deployment/|script/yara_quality_gate\.sh$|yara-protected-paths\.txt$)'; then
  echo "Critical paths changed. CODEOWNERS approval must be enforced by the repository Ruleset."
fi

echo "YARA Policy Check passed."
