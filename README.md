# README

##  Build URL Shortener

The Idea behind this application is to generate a sortened urls and list the Top 100  accessed urls. 
The application consist of an API and a monolith application with the traditional Views(for visualization purposes).

## Code to understand the algorithm :

https://stackoverflow.com/questions/742013/how-to-code-a-url-shortener


## Good Practices and Philosophy

I try to use good practices. Some of them:

Try to keep the code DRY, avoiding duplication
Also Im using service objects to extract the Bussines logic.
There is an implementation for an Async Job to update the Url Tittle
Y also avoided the use of rescue clauses in the code, following the Shopify Style guide for it.

## Gems Used

Some of the gems used in the application

 * Rspec
 * bootstrap-sass
 * rails-controller-testing
 * Mechanize
 * MySQL

## Installation

Run 

 * bundle install
 * bundle exec rake db:create
 * bundle exec rake db:migrate

Please be aware that you need to have MySQL installed.

## App Documentation API

Here is an example to test the endpoints with curl:

```
curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/v1/urls -d "{\"url\" : { \"url\" : \"https://drive.google.com/\"}}"

```

Here is also the url for the bot, to generate 10 URL random:

```
curl -XPOST http://localhost:3000/api/v1/bot

```

Example To get the 100 Top URLS

```
curl http://localhost:3000/api/v1/top

```

## UI

![alt text](https://github.com/JhonnyM/build_short_url/blob/main/pic1.png?raw=true)

![alt text](https://github.com/JhonnyM/build_short_url/blob/main/pic2.png?raw=true)