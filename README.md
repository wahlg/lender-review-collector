# Lending Tree Review Collector
A Ruby on Rails application for collecting review data from https://www.lendingtree.com/reviews and returning it in JSON format

Written by Greg Wahl

Ruby Version: 2.4.1

Rails Version: 5.2.3

## Setup

Install required dependencies:
```
gem install bundler
bundle i
```
Start the application
```
rails s
```

## Using the Application
Encode a URL of a Lending Tree page with reviews (e.g. https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183)

You can use this tool to encode the URL: https://www.urlencoder.org/

Use the encoded in url in the `url` parameter of the request like this:
```
http://localhost:3000/api/v1/reviews?url=https%3A%2F%2Fwww.lendingtree.com%2Freviews%2Fpersonal%2Ffirst-midwest-bank%2F52903183
```
Example JSON response:
```
{
   "result":[
      {
         "title":"Great experience ",
         "content":"The process was easy and Everyone was very helpful and answered any questions I had. Whole process took less than a week.",
         "stars":5,
         "author":"Andrea",
         "date":"2019-05-01",
         "location":"RICHMOND, IN"
      },
      {
         "title":"Excellent experience!",
         "content":"Cassie N. was great and very prompt in her communications with us. My husband and I wanted to refinance some credit card debt and First Midwest Bank came through for us. We weren't approved at first but when I provided more detailed income information we were quickly approved and received the money quickly. As per the loan agreement, the bank sent checks directly to a couple of creditors to ensure they were paid off and the checks arrived in less than a week. It feels really good to be able to continue on my plan to be completely debt free in 3 years! Thanks FMB \u0026 Cassie!",
         "stars":5,
         "author":"Rachel",
         "date":"2019-05-01",
         "location":"BLUEFIELD, VA"
      },
      {
         "title":"Awesome experience!! ",
         "content":"TeAnna made the process so easy and quick!! Great communication, via email which worked best for me. ",
         "stars":5,
         "author":"Jenny",
         "date":"2019-05-01",
         "location":"KANSAS CITY, MO"
      },
      {
         "title":"Best Experience I've Ever Had!!!",
         "content":"Wow!! Just funded a loan I applied for four days ago! The application process, the review process, the underwriting process and the customer service was the best I've experienced with any bank! And I couldn't find a better rate or cheaper closing costs anywhere in the country! First Midwest Bank is the real deal.Thank you Patrick, for representing the bank so well and making sure I was taken care of in a timely manner. The fantastic customer service just made the process that much easier and I will definitely be doing business with you again.",
         "stars":5,
         "author":"John",
         "date":"2019-05-01",
         "location":"THOUSAND OAKS, CA"
      }
   ],
   "error":null
}
```

Any errors returned will be in the `"error"` section of the response. Otherwise the reviews will be returned in a JSON array with the following keys:

* title: The title of the review
* content: The full content of the review
* stars: The star rating of the review 1-5
* author: The first name of the review author
* date: The month and year the review was written
* location: The city and province of the reviewer

## Testing
You can run the full RSpec test suite with:
```
rspec spec/
```
