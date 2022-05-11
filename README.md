# YmlRecord

YmlRecord is a gem to allow easy instantiating of classes from a yml file and exposing an ActiveRecord-esque api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yml_record'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install yml_record

## Usage
Create an ApplicationYmlRecord model that inherits from YmlRecord::Base.  
N.B: setting `abstract_class = true` avoids having to set a yml file for `ApplicationYmlRecord`.  
```
  # app/models/application_yml_record.rb
  class ApplicationYmlRecord < YmlRecord::Base
    self.abstract_class = true
  end
```

Create a model that will be backed by a yml data file and inherit from ApplicationYmlRecord.
```
  # app/models/example_model.rb
  class ExampleModel < ApplicationYmlRecord; end
```

Add a yml file (named the same as your model) to the `config/data/` folder
```
  # config/data/example_model.yml
  - id: 1
    name: one
  - id: 2
    name: two
```

This model can now be used as if it were backed by activerecord and a database table.
N.B: this functionality does not include create or update actions.

```
ExampleModel.all #=> relation of 2 instances
ExampleModel.where(name: 'one') #=> relation of 1 (first) instance
ExampleModel.find(1) #=> first instance of ExampleModel
etc
```

The automatic folder location for the yml files is `config/data/` but this can be manually overwritten
The automatic file name for each model is the demodulized snakecase class name (e.g `App::ExampleClass` => `example_class.yml`)

This automatic functionality can be overwritten when needed
```
  # to overwrite individual class's data filename to `bar.yml`
  class Foo < ApplicationYmlRecord
    self.filename = 'bar'
  end

  # to overwrite data folder location
  class ApplicationYmlRecord < YamlRecord::Base
    self.filepath = 'another/folder'
  end
```
will look for data in `another/folder/bar/yml`

See below for specific functionality implementations.
The implementation examples assume the following setup
```
# example.yaml
- id: 1
  old: true
  colour: :green
- id: 2
  colour: :red
  old: true
- id: 3
  colour: :red
  old: false

class Example < YamlRecord::Base
end
```

### Class methods
#### Scopes
Scopes will return a chainable relation with instances that match the attributes similar to active record relations
```
Example.where(old: true).where(colour: :red) #=> [<Example id: 1 />]
is the same as 
Example.where(old: true, colour: :red)
```

#### Has Many
Will add method to return the child relation 

### Instance methods
#### Boolean methods

When an attribute is a boolean a boolean instance method is automatically created.
```
Example.find(1).old? #=> true
Example.find(2).old? #=> false
```

### TODO documentation
TODO: document implementation of custom filename  
TODO: document implementation of custom identifier  
TODO: document implementation of scope  
TODO: document implementation of enum  

## Future implementations
TODO: document

- [ ] default boolean methods. Currently need to specifically set up boolean methods.  
- [ ] setting data folder in initializer for gem
- [ ] allow setting of specific data for specific deployments


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tjbarker/yml_record. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tjbarker/yml_record/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YmlRecord project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tjbarker/yml_record/blob/master/CODE_OF_CONDUCT.md).
