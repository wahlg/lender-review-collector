require 'rails_helper'

describe UrlValidators::LendingTreeUrlValidator do
  subject { UrlValidators::LendingTreeUrlValidator }

  let(:valid_url) { 'https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183' }

  describe '#validate!' do
    it 'raises an exception if the domain is not lending tree domain' do
      expect { subject.validate!(URI.parse('http://example.com')) }
        .to raise_error(
          Exceptions::UrlValidationException,
          "Provided URL is not a valid Lending Tree URL: 'http://example.com'"
        )
    end

    it 'raises an exception if not on the /reviews page' do
      expect { subject.validate!(URI.parse('https://www.lendingtree.com/something/else')) }
        .to raise_error(
          Exceptions::UrlValidationException,
          "Provided URL is not under path '/reviews': 'https://www.lendingtree.com/something/else'"
        )
    end

    it 'does not raise an exception if url is valid' do
      expect { subject.validate!(URI.parse('https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183')) }
        .not_to raise_error
    end
  end
end
