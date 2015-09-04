# Hey!

Hey is a lightweight pubsub wrapper that makes it easy to change underlying messaging implementations and also includes
some convenience utilities to:

* Track a chain of events
* Sanitize sensitive data from event payloads
* Set arbitrary data that will be included on every event published on the same thread

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hey-pubsub', require: 'hey'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hey-pubsub

## Why use Hey?

We often treat logging, exception notification and event broadcasting as separate operations within our code. Hey
encourages you to treat everything as a published event that is meaningful to the current operation being performed.

Any number of subscribers may react to the event once it's published. For example a published registration failure event
could have a logstash subscriber logging the failure details into Kibana and a HoneyBadger subscriber recording the exception
and notifying the dev team. A successful registration event, on the other hand, could trigger a welcome email delivery.

The utilities Hey provides, such as data sanitization, makes it more appealing to combine these logging and pubsub use cases.
Additionally the ability to switch out messaging implementations means you start with a simple approach (ActiveSupport
Notifications) and ease into using a more distributed, asynchronous approach as your application grows without changing
your code.

## Shared Metadata

Hey provides utilities to share metadata across all events published on the same thread.

### Event chain UUID

The first time an event is published via Hey a UUID will be assigned and stored on the current thread.

Any events published for the life of the current thread with include this `uuid` in their payloads. This allows a
chain of events to be associated later in a Kibana dashboard, for example.

This UUID could be used across disparate systems subscribing to the same message bus, so long as the convention is
adhered to.

### Contexts

Use contexts if you want to attach meta-data to all events that happen on a thread from a certain point forward.

```ruby
Hey.context(ip_address: "127.0.0.1") do
  Hey.publish!("registration.succeeded", { email: "john@ecommerce.com" })
end
```

The payloads of all events wrapped in a context will include this extra data.

You may also nest contexts:

```ruby
Hey.context(ip_address: "127.0.0.1") do
  Hey.context(current_actor: "Jack Ship") do
    Hey.publish!("registration.succeeded", { email: "john@ecommerce.com" })
  end
end
```

#### Sanitizing payloads

There are times you'd like sensitive information to be stripped from event payloads. For example, if you are logging API
requests and responses you should redact credentials before writing to a database or logfile.

It's easier to handle this sanitization during publication, since subscribers of the events will likely not know what
values to strip. Hey provides a utility to record these sensitive values and every event published during the life of
the current thread will redact them from their payloads.

You can sanitize data by using the key `sanitize` in your contexts:

```ruby
Hey.context(sanitize: ["227-76-1234"]) do
  Hey.publish!("registration.succeeded", { email: "john@ecommerce.com" })
end
```

#### Namespacing events

You can automatically namespace your event names using contexts and a top-level namespace.

A top-level namespace can be configured like this:

```ruby
Hey.configure do |config|
  config.global_namespace = “my-app”
end
```

As can a delimiter for chaining an event name together, the default of which is “:” :

```ruby
Hey.configure do |config|
  config.delimiter = “/”
end
```

With this configuration, an event’s name would look like this:

```ruby
Hey.publish!("registered", { email: "john@ecommerce.com" })
=> "my-app/registered"
```

You can also set a namespace on contexts and they will automatically be chained together in the order they are nested:

```ruby
Hey.context(namespace: “foo”) do
  Hey.context(namespace: “bar”) do
    Hey.publish!(“hooray”)
  end
end

=> "foo:bar:hooray"
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
Hey.subscribe!("registration.succeeded") do |payload|
  email = payload["email"]
  RegistrationMailer.new_customer(email).deliver
end
```

## Middleware

A faraday middleware adapter is provided to automatically broadcast all requests and responses.

```ruby
faraday_connection = ::Faraday.new(url: base_url) do |faraday|
  faraday.use Hey::Pubsub::Middleware::Faraday
  faraday.adapter ::Faraday.default_adapter
end
```

It will broadcast the event names "request" and "response", so be sure to use contexts and namespacing to make the event names more meaningful.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ShippingEasy/hey-pubsub.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
