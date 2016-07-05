require 'spec_helper'

describe CodeStats::Metrics::Reporter do
  it 'has a version number' do
    expect(CodeStats::Metrics::Reporter::VERSION).not_to be nil
  end
end
