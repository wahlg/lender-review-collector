require 'rails_helper'

describe Parsers::LendingTreeParser do
  subject { Parsers::LendingTreeParser }

  let(:example_response_data) do
    File.read(
      Rails.root.join('spec', 'fixtures', 'lending_tree', 'example_response.html')
    )
  end
  let(:example_incomplete_response_data) do
    File.read(
      Rails.root.join('spec', 'fixtures', 'lending_tree', 'example_incomplete_response.html')
    )
  end
  let(:example_parsed_response_data) do
    File.read(
      Rails.root.join('spec', 'fixtures', 'lending_tree', 'example_parsed_response.json')
    )
  end

  describe '#parse!' do
    it 'raises an exception if the page is incomplete' do
      expect { subject.parse!(example_incomplete_response_data) }
        .to raise_error(Exceptions::ParsingException, 'Unable to parse requested url')
    end

    it 'raises an exception if no reviews are found' do
      expect { subject.parse!('<html />') }
        .to raise_error(Exceptions::ParsingException, 'No review data found while parsing page')
    end

    it 'returns the correct data when it can parse successfully' do
      result = subject.parse!(example_response_data)
      expected_data = JSON.parse(example_parsed_response_data).map{ |r| r.symbolize_keys }
      expect(result).to match_json_expression(expected_data)
    end
  end
end
