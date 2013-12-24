# Standings

A ruby gem to quickly add leaderboard functionality to any existing model in a rails application. This gem makes it easy to add leaderboards not only in games, where they are usually used but also into any other application which contains rankable models.

## Installation

Add this line to your application's Gemfile:

```ruby
    gem 'standings'
```

And then execute:

```
    $ bundle
```

Or install it yourself as:

```
    $ gem install standings
```

## Basic Usage

Consider you have a `Movie` model which has a `views` column that stores the number of times users have viewed the movie.

```ruby
class Movie < ActiveRecord::Base
  extend Standings::ModelAdditions

  rank_by :views
end
```

### Class methods

The gem will automatically add the `top_movies` class method to the `Movie` class which will return the top 3 movies based on the number of views. The method also takes an optional parameter that specifies the number of movies needed. Based on the above example, the output of the `top_movies` method will be as follows:

```ruby
  Movie.top_movies # Will return the 3 movies "Pulp Fiction", "Reservoir Dogs" & "Kill Bill"
  Movie.top_movies(2) # Will return the 2 movies "Pulp Fiction" & "Reservoir Dogs"
```

### Instance methods

The gem will automatically add the following instance methods to the `Movie` class :

* `current_movie_rank` : This method can be used to determine the movie's rank based on the number of views.

* `movies_around` : This method returns an array of 5 movies that are around the current movie i.e. 2 movies on either side of the current movie including the current movie.

* `leaderboard` : This method returns a hash containing results from all three methods `current_movie_rank`, `movies_around` and `top_movies`.
It takes an optional argument(integer) to limit the number of records returned from `top_movies` method.

For example consider the following movies in the database:

<table>
    <tr>
        <th>Name</th>
        <th>Views</th>
        <th>Profit</th>
    </tr>
    <tr>
        <td>Pulp Fiction</td>
        <td>50</td>
        <td>$500</td>
    </tr>
    <tr>
        <td>Reservoir Dogs</td>
        <td>40</td>
        <td>$600</td>
    </tr>
    <tr>
        <td>Kill Bill</td>
        <td>30</td>
        <td>$200</td>
    </tr>
    <tr>
        <td>Death Proof</td>
        <td>20</td>
        <td>$100</td>
    </tr>
    <tr>
        <td>Jackie Brown</td>
        <td>10</td>
        <td>$400</td>
    </tr>
</table>

The output of the 2 methods will be as follows:

```ruby
  pulp_fiction   = Movie.find_by_name("Pulp Fiction")
  reservoir_dogs = Movie.find_by_name("Reservoir Dogs")
  kill_bill      = Movie.find_by_name("Kill Bill")
  death_proof    = Movie.find_by_name("Death Proof")
  jackie_brown   = Movie.find_by_name("Jackie Brown")

  kill_bill.current_movie_rank # => 3
  kill_bill.movies_around # => [pulp_fiction, reservoir_dogs, kill_bill, death_proof, jackie_brown]
  kill_bill.leaderboard(2) # => {current_movie_rank: 3, movies_around: [pulp_fiction,reservoir_dogs,kill_bill,death_proof,jackie_brown], top_movies: [pulp_fiction,reservoir_dogs]}

  reservoir_dogs.current_movie_rank # => 2
  reservoir_dogs.movies_around # => [pulp_fiction, reservoir_dogs, kill_bill, death_proof]
  reservoir_dogs.leaderboard # => {current_movie_rank: 2, movies_around: [pulp_fiction, reservoir_dogs, kill_bill, death_proof], top_movies: [pulp_fiction, reservoir_dogs,kill_bill]}
```

## Additional Options

### :around_limit

The default number of objects returned by `movies_around` can be overwritten using the option `around_limit`. In the example below, we set the option to 1 forcing the gem to return at most 1 movie before and after the current movie:

```ruby
class Movie < ActiveRecord::Base
  extend Standings::ModelAdditions

  rank_by :views, around_limit: 1
end

kill_bill = Movie.find_by_name("Kill Bill")
kill_bill.movies_around # => [reservoir_dogs, kill_bill, death_proof]
```

### :sort_order

```ruby
class Movie < ActiveRecord::Base
  extend Standings::ModelAdditions

  rank_by :views, sort_order: ["released_on asc", "number_of_awards desc"]
end
```

The gem also allows you to specify additional sort orders to resolve conflicts when there are a bunch of movies with the same number of views. The additional sort order can be specified as shown above. In this case, if two movies have the same number of views, the one released earlier will have a higher ranking. In case the number of views and the release date is the same, the one with more awards will have a higher ranking.

If the `:sort_order` is not specified, the conflicts will be resolved using the `id asc` sort order.


## Custom Leaderboards

The gem will automatically add the `add_leaderboard` class method to the Movie class which will allow
you to configure custom leaderboards.
This method takes these arguments: `name`, `column_name`, `sort_order`, `around_limit`.

```ruby
class Movie < ActiveRecord::Base
  extend Standings::ModelAdditions

  add_leaderboard :most_profitable, :profit, sort_order: %w(name), around_limit: 1
  # This will add the :most_profitable instance method.
  # It also takes an optional argument(integer) to limit the number of records returned from `top_movies` method.
end

pulp_fiction   = Movie.find_by_name("Pulp Fiction")
reservoir_dogs = Movie.find_by_name("Reservoir Dogs")
kill_bill      = Movie.find_by_name("Kill Bill")
death_proof    = Movie.find_by_name("Death Proof")
jackie_brown   = Movie.find_by_name("Jackie Brown")

pulp_fiction.most_profitable # => {current_movie_rank: 2, movies_around: [reservoir_dogs, pulp_fiction, jackie_brown], top_movies: [pulp_fiction, reservoir_dogs, kill_bill]}

death_proof.most_profitable(2) # => {current_movie_rank: 6, movies_around: [kill_bill, death_proof], top_movies: [pulp_fiction, reservoir_dogs]}
```

## Roadmap
* Scopes - Calculate leaderboards and ranking for a specific scope. For example, this will help us generate leaderboards for all movies released in 2012 or for all movies produced by DreamWorks, etc.


## Authors
* Nitin Misra: https://github.com/nitinstp23
* Rakesh Verma: https://github.com/rakesh87


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
