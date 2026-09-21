require 'rails_helper'

RSpec.describe V2::Reports::OutgoingMessagesCountBuilder do
  it 'rejects unsupported groupings before querying the database' do
    builder = described_class.new(nil, { group_by: '__send__' })

    expect { builder.build }.to raise_error(ArgumentError, 'Unsupported report grouping')
  end

  %w[agent team inbox label].each do |grouping|
    it "uses the supported #{grouping} report" do
      builder = described_class.new(nil, { group_by: grouping })
      allow(builder).to receive("build_by_#{grouping}").and_return([])

      expect(builder.build).to eq([])
    end
  end
end
