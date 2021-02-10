# ShipyardExporter

All-in-one Exporter for Rails app.

![Work in progress](work-in-progress.png)

*\*currently only support CSV and XLSX export format*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shipyard_exporter', git: 'git@github.com:yzgan/shipyard_exporter.git'
```

And then execute:

    $ bundle install

## Usage


Enable export feature for model.

Include `ShipyardExporter::Exportable` module at model to import features at model file.

**app/models/admin.rb**
```rb
include ShipyardExporter::Exportable
```
Following methods will be available. Export to csv or xlsx with all attributes defined in column names
```rb
Admin.to_csv
Admin.to_xlsx
```
Export to csv or xlsx with scoped attributes and row titles
```rb
Admin.export(format: :csv, attributes: %w[id name], row_titles: ['ID', 'Full name'])
Admin.export(format: :xlsx, attributes: %w[id name email], row_titles: ['ID', 'Full name', 'Email'])
```
For customization, define attributes and titles in model and it will overwrite to `#to_csv` method
```rb
exportable titles: %w[Email UserID Name Phone Wearable Date],
           attributes: %w[user.email user_id user.full_name user.phone wearable wearable_type.name date]

```
## Optional
### draper gem integration
support decorator/view models with `draper` gems.
```rb
exportable titles: ['ID', 'Name', 'Serving type', 'Created at'],
           attributes: %i[id name serving_type created_at],
           decorate: true
```
**app/decorators/food_decorator.rb**
```rb
class FoodDecorator < ApplicationDecorator
  delegate_all

  def serving_type
    object.serving_type&.name
  end
end
```


## Full Example
**app/models/food.rb**
```rb
class Food < ApplicationRecord
  include ShipyardExporter::Exportable

  belongs_to :serving_type

  exportable titles: ['ID', 'Name', 'Serving type', 'Created at'],
             attributes: %w[id name serving_type.name created_at],
             decorate: true
end
```

**app/controllers/foods_controller**
```rb
class FoodsController < ApplicationController>
  def index
    @movies = Food.all

    respond_to do |format|
      format.html
      format.json { render json: @movies }
      format.csv { send_data Food.to_csv, filename: 'foods.csv' }
      format.xlsx { send_data Food.to_xlsx, filename: 'foods.xlsx' }
    end
  end
end
```

rails console
```sh
irb(main):003:0> Movie.to_csv
Movie: initiating exporting to csv
"ID,Name,Serving type,Created at\n3,Yogurt,Cup,\"Friday, January 22, 2021 13:00\"\n"
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shipyard_exporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/shipyard_exporter/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ShipyardExporter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/shipyard_exporter/blob/master/CODE_OF_CONDUCT.md).
