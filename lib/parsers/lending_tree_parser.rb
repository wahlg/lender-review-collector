module Parsers
  class LendingTreeParser
    STANDARD_ERROR_MESSAGE = 'Unable to parse requested url'.freeze
    NO_DATA_ERROR = 'No review data found while parsing page'.freeze

    class << self
      def parse!(html)
        data = []
        page = Nokogiri::HTML(html)
        page_reviews = page.css('div.mainReviews')
        page_reviews.each do |page_review|
          data << parse_review_data(page_review)
        end
        if data.blank?
          raise Exceptions::ParsingException.new(NO_DATA_ERROR)
        end
        data
      end

      private

      def parse_review_data(page_review)
        {
          :title    => page_review.css('div.reviewDetail')
                                  .css('p.reviewTitle').text,
          :content  => page_review.css('div.reviewDetail')
                                  .css('p.reviewText').text,
          :stars    => page_review.css('div.starReviews')
                                  .css('div.rating-stars-wrapper')
                                  .css('div.rating-stars-bottom')
                                  .css('span.lt4-Star')
                                  .length,
          :author   => page_review.css('div.reviewDetail')
                                  .css('div.hideText')
                                  .css('p.consumerName')
                                  .children[0]
                                  .text
                                  .strip,
          :date     => parse_date(page_review),
          :location => page_review.css('div.reviewDetail')
                                  .css('div.hideText')
                                  .css('p.consumerName')
                                  .css('span')
                                  .text
                                  .gsub(/^from/, '')
                                  .strip
        }
      rescue StandardError => e
        raise Exceptions::ParsingException.new(STANDARD_ERROR_MESSAGE)
      end

      def parse_date(page_review)
        raw_date = page_review.css('div.reviewDetail')
                              .css('div.hideText')
                              .css('p.consumerReviewDate')
                              .text
                              .gsub(/^Reviewed in/, '')
                              .strip
        Date.parse(raw_date).to_s
      end
    end
  end
end
