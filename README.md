# UrlShorten

UrlShorten is a web app, that can create a URL-shortening service using Ruby.

## Installation

* Install docker and docker-compose. refs: [docker installation](https://docs.docker.com/compose/).
* Run at the terminal
```bash
docker-compose build
docker-compose up
```
* Access the app at [here](http://localhost:3001).
* Run unittest with cmd:
```bash
docker-compose exec -e RAILS_ENV=test app bundle exec rspec
```

## How to use

At [http://localhost:3001](http://localhost:3001), you will see 2 forms encode and decode.

## Security

1. CSRF attacks

* Each request to `/encode` or `/decode`, the server always verifies `authenticity_token` by `protect_from_forgery` function.
* This token was created by RAILS and verified with each HTTP POST request, based on SESSION.

2. XSS attacks

* Server: 2 field URL and short_url were validated by regex, do not allow saving malicious scripts to the database.
* Client: Use `.text()` function to help us escape HTML when show data in the browser.

3. SQL Injection

* With mongoid ODM help us generate queries to DB, minimize this attack.

4. CORS

* Setting allow origin with my domain, the server only received requests have origin header from my domain.
(In my app, allow_origins set `*` because it hasn't domain. Regex at config/initializers/cors.rb:2 can apply when it has domain)

4. cookies

* Set `http_only` flag is true, keep cookies can not access or update by script.
* Set `secure` flag is true, help encode cookies and cookies only active with `HTTPS`.

5. DDoS

* Use Route 53 and AWS Shield to reduce DDoS attack. (Don't apply for my app, because them aren't free).

## Problem

Generate short URL duplicate

I choose this random algorithm to reduce issues:
* Suppose my key has 2 characters, I will random each character of the key in the characters sample set, suppose the sample set has 10 characters.
* We have probability with 1 key: (1/10 * 1/10) * 10 = 1%
* With characters in each key increased and the sample set also increased, duplication probability is very small.

When the number of links were increased, generate key can duplicate. I handled allowing loop generate until the key is unique and limited retry count for this loop.

When duplicates are easy to occur, we can increase key size and sample set size easily with:
```ruby
 shorten_url_with :url, :short_url, key_length: KEY_LENGTH, key_chars: SAMPLE_SET
```

## Scalability

When the app has more users used, the amount of documents in DB increases by hundreds of million. Instead of increase `key size`. We can have more domains for short URLs, which users can choose.

About DB, each domain can store in a collection to speed up performance. To develop in this direction, the developer need only use the method `shorten_url_with` to scale up the system.

I choose MongoDB because The data in the system is not relation.

## deployment

It is free ec2 aws, so it doesn't running often. please contact me if you have issue with it. sorry for this inconvenience.
![image](https://user-images.githubusercontent.com/33271704/205663835-08a26ad5-2d7d-43e8-8497-871c59d0fa5d.png)

