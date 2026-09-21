# Security review of the development baseline

This is a code-review record, not a claim that the application is free of vulnerabilities.
The security job remains blocking. No Brakeman check class, confidence level, or directory is disabled.

## Corrected findings

- Updated vulnerable Rails, mail and RubyLLM dependencies; Rails 8.1 is now required.
- Removed dynamic method dispatch from reporting metrics and grouping.
- Anchored phone validation to the whole input.
- Escaped widget script configuration as JSON and sanitized the plan label HTML.
- Removed account selectors from profile mass assignment; membership lookup is scoped to the current user.
- Platform bot creation/reassignment now checks permission to the destination account and cannot broaden an account bot to global scope.
- Search date comparisons use Arel predicates instead of interpolated column SQL.
- Conversation metadata is restricted to its JSON containers, not top-level ownership fields.

## Individually reviewed Brakeman findings

`config/brakeman.ignore` records exact fingerprints and per-finding reasons, not a blanket baseline.
Changed/new findings must be reviewed again. Keep these entries under owner-controlled review.

### Captain statistics (10 SQL findings)

`enterprise/app/builders/captain/assistant_stats_builder.rb` constructs aggregate expressions from model enum integers, fixed event-name constants, dates escaped with the database adapter's `quote`, and account/assistant-scoped ActiveRecord subqueries rendered by `to_sql`. No caller-supplied SQL fragment is accepted. The `suggestions_scope` is an internal ActiveRecord relation, not an HTTP parameter.

Existing coverage: `spec/enterprise/builders/captain/assistant_stats_builder_spec.rb`. This enterprise suite is separate from the CE matrix; its presence alone is not evidence that it ran in that matrix.

### Filter query construction (1 SQL finding)

`FilterService#query_builder` combines validated operators and attributes. Both Contacts and Conversations services validate logical operators before calling it. `Filters::FilterHelper` restricts AND/OR, checks standard attributes/operators against checked-in YAML and rejects unknown attributes. Custom fields are resolved within the account and keys are escaped; values use named bindings. The account-scoped base relation is retained.

Existing coverage: `spec/services/contacts/filter_service_spec.rb` includes invalid logical operators and malicious date payloads; conversation filter specs cover their own permission-filtered relation.

### Filter/export request envelopes (3 mass-assignment findings)

Contacts export/filter and conversation filter pass query envelopes to the filter services, not directly to ActiveRecord assignment. Export uses explicit current account/user IDs and selects the payload/label fields. The warning is about `permit!` syntax; authorization and SQL safety still depend on the invariants above.

### Slack envelope (1 mass-assignment finding)

The integration webhook forwards an event envelope to `Integrations::Slack::IncomingMessageBuilder`, which dispatches supported event types and selects fields through the message helper. It does not mass-assign that envelope into a model. This classification does **not** certify webhook signature verification or all downstream Slack behavior; those are separate security questions. Existing coverage: `spec/lib/integrations/slack/incoming_message_builder_spec.rb`.

### Platform account roles (1 mass-assignment finding)

Role assignment is intentional for a PlatformApp managing an account. `PlatformController` authenticates the PlatformApp token and `AccountUsersController` checks that the selected account is a permissible resource before every action. The membership is built through that account's association. Existing coverage: `spec/controllers/platform/api/v1/account_users_controller_spec.rb`, supplemented by unauthorized-account regression coverage.

## Remaining boundaries

- `.bundler-audit.yml` retains three inherited, documented exceptions; do not describe the dependency audit as having no exceptions.
- No customer database, production credentials, or server configuration is copied into this repository.
- Passing this branch's tests does not deploy it or prove the remote Customer 360 integration works.
- Vendored compatibility libraries retain their original licenses and document changes in `YARA_PATCH.md`; review their maintenance when updating upstream.
