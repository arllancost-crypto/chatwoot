require 'rails_helper'

RSpec.describe RubyLlmMessageCompatibility do
  it 'preserves actual token usage from RubyLLM 2 messages' do
    message = RubyLLM::Message.new(role: :assistant, content: 'Offline test', input_tokens: 12, output_tokens: 7)

    expect(message.input_tokens).to eq(12)
    expect(message.output_tokens).to eq(7)
  end

  it 'preserves unknown usage rather than reporting zero' do
    message = RubyLLM::Message.new(role: :assistant, content: 'Offline test')

    expect(message.input_tokens).to be_nil
    expect(message.output_tokens).to be_nil
  end
end
