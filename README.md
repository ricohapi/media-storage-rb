# Ricoh Media Storage for Ruby

Ricoh Media Storage API Client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ricohapi-mstorage'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ricohapi-mstorage

## Usage

You can find [a working rails sample app using Ricoh Media Storage API](https://github.com/ricohapi/media-storage-sample-app).

### Media Storage API Client

```ruby
mstorage = RicohAPI::MStorage::Client.new(
  '<your-access-token>'
)

# GET /v1/media
mstorage.list
mstorage.list limit: 25
mstorage.list after: '<cursor-id>'

# GET /v1/media/{media-id}
mstorage.info '<media-id>'

# GET /v1/media/{media-id}/meta
mstorage.inspect '<media-id>'

# GET /v1/media/{media-id}/content
mstorage.download '<media-id>'

# POST /v1/media (multipart)
mstorage.upload content: file

# DELETE /v1/media/{media-id}
mstorage.delete '<media-id>'
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

