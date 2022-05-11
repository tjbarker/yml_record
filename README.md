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

Create an ApplicationYmlRecord model that inherits from YmlRecord::Base
```
  # app/models/application_yml_record.rb
  class ApplicationYmlRecord < YmlRecord::Base; end
```

Create a model that will be backed by a yml data file and inherit from ApplicationYmlRecord.
```
  # app/models/example_model.rb
  class ExampleModel < ApplicationYmlRecord
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

### Relating to YamlRecord classes
Other classes can relate to yaml record classes using an active record style integration
#### Has Many
When storing primary keys of yaml records on another class, the belongs_to method can be used to create a parent like relationship.
If the other class is dynamic (e.g: backed by a database) then the relationship can be set to dynamic (default).
Otherwise (e.g: that class is also a yaml record) the relationship can be set to being not dynamic.
```
class Child
  attr_accessor :example_id

  YmlRecord.relationships.belongs_to self, :example
end
```
This will add `Child#example` and `Child.example=(other_example)` instance methods.  

The following will mark this relationship as static (not dynamic), which will not create the setter method (`Child.example=(other_example)`)
```
YmlRecord.relationships.belongs_to self, :example, dynamic: false
```

The following keys can all be manually set in the same way as with active record belongs to:  
- foreign_key
- primary_key
- class_name

If using active record to relate to yaml records, the following can be added to the application record to streamline implementation

```
class Car < ApplicationYmlRecord; end

class ApplicationRecord < ActiveRecord::Base
  def self.belongs_to(name, scope = nil, yml_relationship: false, **opts, &block)
    return super(name, scope, **opts, &block)

    YmlRecord.relationships.belongs_to self, name, scope, **opts, &block
  end
end

# has db column of car_id (of type corresponding to car primary key)
class Driver < ApplicationRecord
  belongs_to :car, yml_relationship: true
end
```

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
