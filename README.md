# Communication-Platform

## Description

This project provides an email endpoint to trigger an email service. If one of the email services is down or results in an error, an alternate service defined in the project is used.
Currently we support Sendgrid and Postmark APIs to send email.


## Requirements

This project currently works with:

* Ruby 2.6.3
* PostgreSQL
* Sinatra

## Usage

* Run `bundle install`
* Copy `.env.example` to `.env` and add environment variables to `.env`
* Run `rake db:create db:migrate`
* To start the project run `rackup`
* Use `Postman` or `cURL` to send json request to the enpoint
* Send your json `POST` request to `/email` endpoint with the correct email attributes

## What does it do?

This application will perform the following steps:

1. Fetch email parameters from your request
2. Validates the attributes provided
3. Go through a defined hash to look for which service to use
4. Run an API request with NET::HTTP and send payload to the email service provider's API
5. Log the sent email with the API response in the `emails` table
6. The email endpoint does not log unsuccessful email attemps in the table
7. Returns a json response based on the results

## Email request parameters

Not authentication or headers are required for this request
The attributes expected are: `to`, `to_name`, `from`, `from_name`, `body`, `subject`

NOTE: If any of these attributes are missing or unexpected attributes sent, that will result in an error

## Sample Request Body
{
  "to": "your_email",
  "to_name": "reciever_name",
  "from": "reciever_email",
  "from_name": "your_name",
  "subject": "subject",
  "body": "email body"
}

## Delayed Delivery
* Delayed delivery or scheduling is not currently supported by the Postmark API
  - We confirmed this by going through the documentation and contacting the Postmark API support as well
  - Best way to achieve email scheduling with Postmark would be by going with a custom built solution such as cron-jobs
* Email scheduling has been implemented using the Sendgrid API
* If `send_at` attribute is sent the email service API wont switch and only use Sendgrid without alternating to Postmark

## How to use email scheduling
* To use email scheduling make use of the `send_at` attribute. If this attribute is not set the service will default to deliver the email instantaneously
* The format for the  `send_at` attribute uses this format: `DD MM YYYY HR:MIN:SEC +GMT`

* Sample request attributes listed below
 `23 09 2019 18:17:06 -05:00`
 `23 11 2019 07:00:00 +05:00`

* Sample json request with time
 {
  "to": "test@test.com",
  "to_name": "RECIEVER NAME",
  "from": "test@test.com",
  "from_name": "SENDER NAME",
  "subject": "BODY",
  "body": "HTML TEXT",
  "send_at": "23 9 2019 15:00:00 +00:00"
  }

## Webhooks
* We are accepting webhook requests from both Sendgrid and Postmark
* The webhook respones are stored with the event trigger type and other information in a seperate table(`webhook_logs`)
* Sendgrid webhook is recieved at the `/sg_webhook` endpoint
* Postmark webhook is recieved at the `/pm_webhook` endpoint

## Test cases
* Run `rake db:create db:migrate RACK_ENV=test`
* `rack-test` and `rspec` are used for test cases
* `VCR` and `Webmock` is used for API calls
* API calls only run once in test cases and stored to be used in all the next executions
* Database cleaner runs before and after all contexts and before every test suite
* Before running the tests make sure Sendgrid and Postmark API keys are configured correctly
* Add correct and verified `to_email` and `registered_sender` emails according to the API(without this test cases will fail)
* To run all test cases just type `rspec` on your terminal
* To run a specific test file use `rspec -I . spec/<folder_name>/<file_name>`
