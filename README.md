# UrlShorten

UrlShorten is a web app, that can create a URL-shortening service using Ruby.

## Installation

* install docker and docker-compose. refs: [docker installation](https://docs.docker.com/compose/)
* run at the terminal
```bash
docker-compose build
docker-compose up
```
* Access the app at [here](http://localhost:3001)
* run unittest with cmd:
```bash
docker-compose exec -e RAILS_ENV=test app bundle exec rspec
```

## How to use

At [http://localhost:3001](http://localhost:3001), you will see 2 forms encode and decode

## Security

1. CSRF attacks

* protect by `protect_from_forgery`, with each request to `/encode`, `/decode`, the server always verifies authenticity_token
* This token was created by RAILS and verified with each HTTP POST request, based on SESSION.

2. XSS attacks

* Server: 2 field URL and short_url were validated with regex, Not allowing save malicious scripts to the database
* Client: Use function `.text()` to help us escape HTML when show data in the browser

3. SQL Injection

* With mongoid ODM help us generate queries to DB, minimize this attack

4. CORS

* Setting allow origin with my domain, the server only received requests have origin header from my domain

4. cookies

* flag `http_only` set true, help cookies don't act by script
* flag `secure` set true, help encode cookies and cookies only active with `HTTPS`

5. DDoS

* reduce DDoS with Route 53 and AWS Shield. (Don't apply for my app, because I haven't AWS account)

## Problem

Generate short URL duplicate

I choose this random algorithm to reduce issues:
* suppose my key has 2 characters, I will random each character of the key in the characters sample set, suppose the sample set has 10 characters
* We have probability with 1 key: (1/10 * 1/10) * 10 = 1%
* With characters in each key increased and the sample set also increased, duplication probability is very small

When the number of links were increased, generate key can duplicate. I handled allowing loop generate until the key is unique and limited retry count for this loop

When duplicates are easy to occur, we can increase key size and sample set size easily with:
```ruby
 shorten_url_with :url, :short_url, key_length: KEY_LENGTH, key_chars: SAMPLE_SET
```

## Scalability

When the app has more users used, the amount of documents in DB increases by hundreds of million. Instead of increase `key size`. We can have more domains for short URLs, which users can choose.

About DB, each domain can store in a collection to speed up performance. To develop in this direction, the developer need only use the method `shorten_url_with` to scale up the system

I choose MongoDB because The data in the system is not relation.
