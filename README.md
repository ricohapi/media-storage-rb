# Ricoh Media Storage API Client for Ruby

Ricoh Media Storage API Client.

## Requirements

You need

    Ricoh API Client Credentials (client_id & client_secret)
    Ricoh ID (user_id & password)

If you don't have them, please register yourself and your client from [THETA Developers Website](http://contest.theta360.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ricohapi-mstorage'
```

And then execute:

    $ bundle

Or execute the following line to install the gem without bundler.

    $ gem install ricohapi-mstorage

## Usage

You can find [a working rails sample app using Ricoh Media Storage API](https://github.com/ricohapi/media-storage-sample-app).

## SDK API
Add `require 'ricohapi/mstorage'` to use the APIs below.

### Obtain an access token

```ruby
client = RicohAPI::Auth::Client.new '<your-client-id>', '<your-client-secret>'
client.resource_owner_credentials = '<your-user-id>', '<your-password>'
api_session = client.api_token_for! RicohAPI::MStorage::SCOPE
access_token = api_session.access_token
```

### Constructor

```ruby
mstorage = RicohAPI::MStorage::Client.new client
```

or

```ruby
mstorage = RicohAPI::MStorage::Client.new access_token
```

### Upload

```ruby
mstorage.upload content: file
```

### Download

```ruby
mstorage.download '<media-id>'
```

### List media ids
* Without options
You'll get a default list if you do not set any parameters.
```ruby
mstorage.list
```

* With options

You can also use listing options. The available options are `limit`, `after` and `before`.
```ruby
mstorage.list limit: 25
mstorage.list after: '<cursor-id>'
```

* Search

Also, you can get a list searched by user metadata.
```ruby
filter = {'meta.user.<key1>' => '<value1>', 'meta.user.<key2>' => '<value2>'}
mstorage.list limit: 25, after: '<cursor-id>', filter: filter
```

### Delete

```ruby
mstorage.delete '<media-id>'
```

### Get media information

```ruby
mstorage.info '<media-id>'
```

### Attach media metadata
You can define your original metadata as a 'user metadata'.
Existing metadata value for the same key will be overwritten. Up to 10 user metadata can be attached to a media data.

```ruby
mstorage.add_meta '<media-id>', {'user.<key1>' => '<value1>', 'user.<key2>' => '<value2>'}
```

### Get media metadata
* All
```ruby
mstorage.meta '<media-id>'
```

* Exif
```ruby
mstorage.meta '<media-id>', 'exif'
```

* Google Photo Sphere XMP
```ruby
mstorage.meta '<media-id>', 'gpano'
```

* User metadata (all)
```ruby
mstorage.meta '<media-id>', 'user'
```

* User metadata (with a key)
```ruby
mstorage.meta '<media-id>', 'user.<key>'
```

### Delete media metadata
* User metadata (all)
```ruby
mstorage.remove_meta '<media-id>', 'user'
```

* User metadata (with a key)
```ruby
mstorage.remove_meta '<media-id>', 'user.<key>'
```

## References
* [Media Storage REST API](https://github.com/ricohapi/media-storage-rest/blob/master/media.md)
