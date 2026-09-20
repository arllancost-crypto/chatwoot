# Local compatibility patch (not an upstream release)

Source: published ai-agents 0.12.0 gem, https://github.com/chatwoot/ai-agents.
Only lib/, the MIT LICENSE, this notice and a local gemspec are committed.

The gemspec requires corrected RubyLLM 2.0 instead of vulnerable 1.x.
Agents::Tool.param translates the previous desc keyword to the new parameter
API's description keyword. This is provisional until integration tests pass;
successful library loading alone does not prove Captain compatibility.

No production configuration, credentials, or customer data are included.
