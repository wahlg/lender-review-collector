require 'rails_helper'
require Rails.root.join('spec/support/mocks/mock_response')

describe Api::V1::ReviewsController, :type => :controller do
  let(:valid_url) { 'https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183' }

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

  let(:mock_response) { MockResponse.new(example_response_data) }
  let(:mock_incomplete_response) { MockResponse.new(example_incomplete_response_data) }

  describe '#show' do
    context 'errors' do
      it 'returns an error when url parameter is missing' do
        get :show
        expect(JSON.parse(response.body)['error'])
          .to eq('param is missing or the value is empty: url')
      end

      it 'returns an error when provided url is malformed' do
        get :show, :params => { :url => 'httpz:://invalid' }
        expect(JSON.parse(response.body)['error'])
          .to eq("Malformed URL provided: 'httpz:://invalid'")
      end

      it 'returns an error when provided url is not a lending tree url' do
        get :show, :params => { :url => 'http://example.com' }
        expect(JSON.parse(response.body)['error'])
          .to eq("Provided URL is not a valid Lending Tree URL: 'http://example.com'")
      end

      it 'returns an error when url path does not begin with /reviews' do
        get :show, :params => { :url => 'https://www.lendingtree.com/something/else' }
        expect(JSON.parse(response.body)['error'])
          .to eq("Provided URL is not under path '/reviews': 'https://www.lendingtree.com/something/else'")
      end

      it 'returns an error when requested host is unreachable' do
        expect(HTTParty).to receive(:get).and_raise(SocketError.new('something'))
        get :show, :params => { :url => valid_url }
        expect(JSON.parse(response.body)['error'])
          .to eq('Unable to reach specified URL')
      end

      it 'returns an error when HTTP response to lending tree url is not 200' do
        expect(HTTParty).to receive(:get).with(valid_url).and_return(MockResponse.new('<html />', 404))
        get :show, :params => { :url => valid_url }
        expect(JSON.parse(response.body)['error'])
          .to eq('Requested resource returned HTTP status: 404')
      end

      it 'returns an error when no reviews are found on the page' do
        expect(HTTParty).to receive(:get).with(valid_url).and_return(MockResponse.new('<html></html>'))
        get :show, :params => { :url => valid_url }
        expect(JSON.parse(response.body)['error'])
          .to eq('No review data found while parsing page')
      end

      it 'returns an error when expected page contents are incomplete' do
        expect(HTTParty).to receive(:get).with(valid_url).and_return(mock_incomplete_response)
        get :show, :params => { :url => valid_url }
        expect(JSON.parse(response.body)['error'])
          .to eq('Unable to parse requested url')
      end
    end

    context 'success' do
      before(:each) do
        allow(HTTParty).to receive(:get).with(valid_url).and_return(mock_response)
      end

      it 'returns the correct JSON data for all reviews on the page' do
        get :show, :params => { :url => valid_url }
        expected_data = JSON.parse(example_parsed_response_data).map{ |r| r.symbolize_keys }
        expect(JSON.parse(response.body)).to match_json_expression({
          :result => expected_data,
          :error => nil
        })
      end
    end
  end
end
