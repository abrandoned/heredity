# Heredity

Heredity adds on_inherit hooks to Ruby which providing a clean way execute code on inherited classes without the need to override `inherited`. It also adds the ability to specify class instance variables that should be copied to subclasses.

## Installation

Add this line to your application's Gemfile:

    gem 'heredity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heredity

## Usage

#### On inherit

To use Heredity's inheritance hooks, simply call `on_herit` with a block:

```Ruby
class Foo
  on_inherit do
    puts 'Child of Foo!'
  end
end

This is very useful for injecting behavior into subclasses that is dependent on class state (e.g. behavior that relies on the columns of an active record model).

#### Class instance variables

Because class instance variables in Ruby are not inherited (and rightfully so), Heredity provides the ability to define specific class instance variables that should be inherited. To define inheritable attributes:

```Ruby
class Foo
  include Heredity

  inheritable_attributes :bar

  self.bar = {}
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
