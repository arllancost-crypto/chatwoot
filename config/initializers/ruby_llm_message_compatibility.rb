require 'ruby_llm'

# Chatwoot and ai-agents 0.12 use the RubyLLM 1.x token readers.
# RubyLLM 2 retains these values in its Tokens object. Keep the old readers
# until all consumers have migrated; never substitute zero for missing usage.
module RubyLlmMessageCompatibility
  def input_tokens
    tokens.input
  end

  def output_tokens
    tokens.output
  end
end

RubyLLM::Message.include(RubyLlmMessageCompatibility)
