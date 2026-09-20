# Trusted policy activation

The existing PR workflow remains a feedback check, not a trust boundary.
The new pull_request_target workflow executes only the scanner checked out at
the approved base SHA. PR objects are fetched but never checked out or executed.
There are no dependency installs, caches, PR artifacts or production secrets.
The token can read content and publish commit statuses; it cannot write content.
The status is published to the exact evaluated head, not the base commit.

## Initial activation requires the owner's explicit merge authorization

1. Review this bootstrap PR and all required checks. Do not automatically merge.
2. After owner-authorized merge into develop, test a new PR against develop:
   ordinary change passes; replacing the PR scanner cannot make a prohibited
   synthetic change pass. Confirm the reported head SHA and status issuer.
3. Only after verifying that execution, add `YARA Trusted Policy` as a required
   status in the no-bypass ruleset. Existing required checks remain mandatory.
4. Promote the approved policy to master through the same review procedure.
   Until a base contains the scanner, the trusted job must fail closed.
5. Confirm GitHub's Actions event policy permits this workflow. Never switch
   to executing PR code under pull_request_target to solve a failed run.

Only the owner may merge, including changes to the policy itself. No second
reviewer is required for the owner's changes. External contributors must not
receive administration or unrestricted status-writing credentials. A required
status name alone cannot prove workflow identity against other writers able
to forge that status; retain owner-controlled integration and consider an
independent GitHub App for stronger separation of duties.

The regex scanner is a narrow policy check, not comprehensive secret detection.
Passing it does not establish absence of vulnerabilities or allow deployment.
No production or homologation deployment is triggered by these policy files.
