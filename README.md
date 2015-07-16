# Hey!

Hey is a lightweight pubsub wrapper that makes it easy to change underlying messaging implementations and also includes
some convenience utilities to:

* Track a chain of events
* Sanitize sensitive data from event payloads
* Record who originally kicked off the chain of events (the actor)
* Set arbitrary data that will be included on every event published on the same thread

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hey-pubsub'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hey-pubsub

## Shared Metadata

Hey provides utilities to share metadata across all events published on the same thread.

### Setting the current actor

It's often useful to know who kicked off a chain of events, whether it's a user, employee or the system itself via
some automated process. We call this entity the "current actor".

As soon as you know who the current actor is for a a business process, you should set it:

```ruby
Hey.set_current_actor!(id: 13234, type: "Employee", name: "Jack Ship")
```

Any events published for the life of the current thread with include `current_actor` in their payloads.

### Event chain UUID

The first time an event is published via Hey a UUID will be assigned and stored on the current thread.

Any events published for the life of the current thread with include this `uuid` in their payloads. This allows a
chain of events to be associated later in a Kibana dashboard, for example.

This UUID could be used across disparate systems subscribing to the same message bus, so long as the convention is
adhered to.

### Sanitizing payloads

There are times you'd like sensitive information to be stripped from event payloads. For example, if you are logging API
requests and responses you should redact credentials before writing to a database or logfile.

It's easier to handle this sanitization during publication, since subscribers of the events will likely not know what
values to strip. Hey provides a utility to record these sensitive values and every event published during the life of
the current thread will redact them from their payloads.

```ruby
Hey.sanitize!("ABC123", "4222222222222222", "245-65-12763")
```

### Setting arbitrary data

If you need to set arbitrary values to be included on every event payload for the life of a thread, you can:

```ruby
Hey.set(:ip_address, "127.0.0.1")
```
## Event publishing and subscribing

### Adapters

Hey uses an ActiveSupport Notifications adapter by default, which is essentially a synchronous event bus. However it is
easy to configure a different adapter if needed:

```ruby
Hey.configure do |config|
  config.pubsub_adapter = FooBar::RabbitMqAdapter
end
```

__Note: Currently the only adapter is the aforementioned `Hey::Pubsub::Adapters::AsnAdapter`__

### Publishing

To gain all of the `Hey` goodness, you have to of course use the Hey `publish!` method:

```ruby
Hey.publish!("registration.succeeded", { email: "john@ecommerce.com" })
```

The resulting payload would look something like this:

```
{
  uuid: "0a5d3f22-2cff-4126-a791-c4ac31a2a5bb",
  current_actor: {
    id: "123343",
    type: "Employee",
    name: "Jack Ship"
  },
  email: "john@ecommerce.com"
}
```

__Note: Though ASN supports passing objects in payloads since it's all in the same thread, do not do it. If you ever
switch to an asyncronous adapter it will fail. Only pass JSON compatible values.__

### Subscribing

To subscribe to a published event, do this:

```ruby
Hey.subsribe!("registration.succeeded") do |payload|
  email = payload["email"]
  RegistrationMailer.new_customer(email).deliver
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ShippingEasy/hey-pubsub.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
