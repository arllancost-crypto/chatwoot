require 'rails_helper'
require 'agents'

RSpec.describe Agents::Tool do
  it 'preserves the legacy parameter description with RubyLLM 2' do
    tool_class = Class.new(described_class) do
      param :query, type: 'string', desc: 'Search text'
    end

    expect(tool_class.new.parameters_schema.dig('properties', 'query', 'description')).to eq('Search text')
  end

  it 'constructs an agent without contacting a provider' do
    agent = Agents::Agent.new(name: 'Compatibility', instructions: 'Offline test')

    expect(agent).to be_a(Agents::Agent)
  end
end
