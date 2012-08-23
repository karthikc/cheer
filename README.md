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
   rank_by :views
 end
``` 

### Instance methods

This will automatically add the instance methods `current_movie_rank` and `movies_around` to the `Movie` class. The `current_movie_rank` method can be used to determine the movie's rank based on the number of views. The `movies_around` method returns an array of 5 movies that are around the current movie i.e. 2 movies on either side of the current movie and the current movie.

For example consider the following movies in the database:

<table>
    <tr>
        <th>Name</th>
        <th>Views</th>
    </tr>
    <tr>
        <td>Pulp Fiction</td>
        <td>50</td>
    </tr>
    <tr>
        <td>Reservoir Dogs</td>
        <td>40</td>
    </tr>
    <tr>
        <td>Kill Bill</td>
        <td>30</td>
    </tr>
    <tr>
        <td>Death Proof</td>
        <td>20</td>
    </tr>
    <tr>
        <td>Jackie Brown</td>
        <td>10</td>
    </tr>
</table>

The output of the 2 methods will be as follows:

```ruby
  kill_bill = Movie.find_by_name("Kill Bill")
  kill_bill.current_movie_rank # Will return "3"
  kill_bill.movies_around #Will return the 5 movies "Pulp Fiction", "Reservoir Dogs", "Kill Bill", "Death Proof" & "Jackie Brown"

  reservoir_dogs = Movie.find_by_name("Reservoir Dogs")
  reservoir_dogs.current_movie_rank # Will return "2"
  reservoir_dogs.movies_around #Will return the 4 movies "Pulp Fiction", "Reservoir Dogs", "Kill Bill" & "Death Proof"
````

### Class methods

The gem will also add the class method `top_movies` which will return the top 3 movies based on the number of views. The method also takes an optional parameter that specifies the number of movies needed. Based on the above example, the output of the `top_movies` method will be as follows:

```ruby
  Movie.top_movies #Will return the 3 movies "Pulp Fiction", "Reservoir Dogs" & "Kill Bill"
  Movie.top_movies(2) #Will return the 2 movies "Pulp Fiction" & "Reservoir Dogs"
```

## Additional Options

### :around_limit

The default number of objects returned by `movies_around` can be overwritten using the option `around_limit`. In the example below, we set the option to 1 forcing the gem to return at most 1 movie before and after the current movie:

```ruby
 class Movie < ActiveRecord::Base
   rank_by :views, :around_limit => 1
 end
 
 kill_bill = Movie.find_by_name("Kill Bill")
 kill_bill.movies_around #Will return the 3 movies "Reservoir Dogs", "Kill Bill" & "Death Proof"
``` 

### :sort_order

```ruby
 class Movie < ActiveRecord::Base
   rank_by :views, :sort_order => ["released_on asc", "number_of_awards desc"]
 end 
``` 

The gem also allows you to specify additional sort orders to resolve conflicts when there are a bunch of movies with the same number of views. The additional sort order can be specified as shown above. In this case, if two movies have the same number of views, the one released earlier will have a higher ranking. In case the number of views and the release date is the same, the one with more awards will have a higher ranking.

If the `:sort_order` is not specified, the conflicts will be resolved using the `id asc` sort order.

## Roadmap 
* Single Method Call - Add the `leaderboard` instance method to return the results from all 3 methods `current_movie_rank`, `movies_around` and `top_movies` with a single call.
* Multiple configurations - Allow configuring multiple leaderboards (based on different columns) in the same model.
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
