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
  kill_bill.current_movie_rank # Will return 3
  kill_bill.movies_around #Will return the movies Pulp Fiction, Reservoir Dogs, Kill Bill, Death Proof & Jackie Brown

  reservoir_dogs = Movie.find_by_name("Reservoir Dogs")
  reservoir_dogs.current_movie_rank # Will return 2
  reservoir_dogs.movies_around #Will return the movies Pulp Fiction, Reservoir Dogs, Kill Bill & Death Proof
````

The gem will also add the class method `top_movies` which will return the top 3 movies based on the number of views. The method also takes an optional parameter that specifies the number of movies needed. Based on the above example, the output of the `top_movies` method will be as follows:

```ruby
  Movie.top_movies #Will return the movies Pulp Fiction, Reservoir Dogs & Kill Bill
  Movie.top_movies(2) #Will return the movies Pulp Fiction & Reservoir Dogs
```


## Additional Options


## Roadmap 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
