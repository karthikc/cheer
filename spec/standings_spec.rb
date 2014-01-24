require 'spec_helper'

describe Standings do

  context "Students With Equal Score" do
    before do
      Student.delete_all
      @subrat   = Student.create!(name: 'Subrat Behera', score: 23)
      @rakesh   = Student.create!(name: 'Rakesh Verma', score: 22)
      @girish   = Student.create!(name: 'Girish Kumar', score: 21)
      @nitin    = Student.create!(name: 'Nitin Misra', score: 22)
      @bhanu    = Student.create!(name: 'Bhanu Chander', score: 19)
      @prateeth = Student.create!(name: 'Prateeth S', score: 20)
    end

    it "returns leaderboard objects" do
      @subrat.topers.should be_an_instance_of(Standings::Leaderboard)
      @rakesh.topers.should be_an_instance_of(Standings::Leaderboard)
      @girish.topers.should be_an_instance_of(Standings::Leaderboard)
      @nitin.topers.should be_an_instance_of(Standings::Leaderboard)
      @bhanu.topers.should be_an_instance_of(Standings::Leaderboard)
      @prateeth.topers.should be_an_instance_of(Standings::Leaderboard)
    end

    it "returns the current student rank if students with equal score exists" do
      # For students with equal scores, sorting should be done on the basis of id,
      # since the Student model doesn't define sort_order array.
      @bhanu.topers.current_student_rank.should    == 6
      @nitin.topers.current_student_rank.should    == 3
      @subrat.topers.current_student_rank.should   == 1
      @rakesh.topers.current_student_rank.should   == 2
      @girish.topers.current_student_rank.should   == 4
      @prateeth.topers.current_student_rank.should == 5
    end
  end

  context "GameUsers" do
    before do
      GameUser.delete_all
      @dark_lord         = GameUser.create!(name: 'Dark Lord', score: 11)
      @tom_riddle        = GameUser.create!(name: 'Tom Riddle', score: 25)
      @ron_weasely       = GameUser.create!(name: 'Ron Weasely', score: 23)
      @harry_potter      = GameUser.create!(name: 'Harry Potter', score: 14)
      @jack_sparrow      = GameUser.create!(name: 'Jack Sparrow', score: 12)
      @albus_dumbelldore = GameUser.create!(name: 'Albus Dumbelldore', score: 2)
    end

    it "returns leaderboard objects" do
      @dark_lord.high_scorers.should be_an_instance_of(Standings::Leaderboard)
      @tom_riddle.high_scorers.should be_an_instance_of(Standings::Leaderboard)
      @ron_weasely.high_scorers.should be_an_instance_of(Standings::Leaderboard)
      @harry_potter.high_scorers.should be_an_instance_of(Standings::Leaderboard)
      @jack_sparrow.high_scorers.should be_an_instance_of(Standings::Leaderboard)
      @albus_dumbelldore.high_scorers.should be_an_instance_of(Standings::Leaderboard)
    end

    it "returns the current user rank" do
      @dark_lord.high_scorers.current_game_user_rank.should         == 5
      @tom_riddle.high_scorers.current_game_user_rank.should        == 1
      @ron_weasely.high_scorers.current_game_user_rank.should       == 2
      @jack_sparrow.high_scorers.current_game_user_rank.should      == 4
      @harry_potter.high_scorers.current_game_user_rank.should      == 3
      @albus_dumbelldore.high_scorers.current_game_user_rank.should == 6
    end

    it "returns the top rank users" do
      @dark_lord.high_scorers.top_game_users.should       == [@tom_riddle, @ron_weasely, @harry_potter]
      @tom_riddle.high_scorers.top_game_users(2).should   == [@tom_riddle, @ron_weasely]
      @ron_weasely.high_scorers.top_game_users(5).should  == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow, @dark_lord]
      @jack_sparrow.high_scorers.top_game_users(4).should == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow]
      @harry_potter.high_scorers.top_game_users(1).should == [@tom_riddle]
    end

    it "returns user around to current user according score descending" do
      @tom_riddle.high_scorers.game_users_around.should        == [@tom_riddle, @ron_weasely, @harry_potter]
      @harry_potter.high_scorers.game_users_around.should      == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow, @dark_lord]
      @albus_dumbelldore.high_scorers.game_users_around.should == [@jack_sparrow, @dark_lord, @albus_dumbelldore]
    end
  end

  context "GameUsers With Equal Score" do
    before do
      GameUser.delete_all
      @dark_lord           = GameUser.create!(name: 'Dark Lord', score: 11)
      @tom_riddle          = GameUser.create!(name: 'Tom Riddle', score: 25)
      @ivan_potter         = GameUser.create!(name: 'Ivan Potter', score: 14)
      @ron_weasely         = GameUser.create!(name: 'Ron Weasely', score: 23)
      @harry_potter        = GameUser.create!(name: 'Harry Potter', score: 14)
      @jerry_potter        = GameUser.create!(name: 'Jerry Potter', score: 14)
      @jack_sparrow_1      = GameUser.create!(name: 'Jack Sparrow', score: 12, age: 22)
      @jack_sparrow_2      = GameUser.create!(name: 'Jack Sparrow', score: 12, age: 23)
      @albus_dumbelldore   = GameUser.create!(name: 'Albus Dumbelldore', score: 2)
      @duglous_dumbelldore = GameUser.create!(name: 'Duglous Dumbelldore', score: 2)
    end

    it "returns the current user rank if users with equal score exists" do
      @dark_lord.high_scorers.current_game_user_rank.should           == 8
      @tom_riddle.high_scorers.current_game_user_rank.should          == 1
      @ivan_potter.high_scorers.current_game_user_rank.should         == 4
      @ron_weasely.high_scorers.current_game_user_rank.should         == 2
      @harry_potter.high_scorers.current_game_user_rank.should        == 3
      @jerry_potter.high_scorers.current_game_user_rank.should        == 5
      @jack_sparrow_1.high_scorers.current_game_user_rank.should      == 7
      @jack_sparrow_2.high_scorers.current_game_user_rank.should      == 6
      @albus_dumbelldore.high_scorers.current_game_user_rank.should   == 9
      @duglous_dumbelldore.high_scorers.current_game_user_rank.should == 10
    end

    it "returns the top rank users if equal score users exists" do
      @dark_lord.high_scorers.top_game_users.should       == [@tom_riddle, @ron_weasely, @harry_potter]
      @tom_riddle.high_scorers.top_game_users(1).should   == [@tom_riddle]
      @ivan_potter.high_scorers.top_game_users(2).should  == [@tom_riddle, @ron_weasely]
      @ron_weasely.high_scorers.top_game_users(4).should  == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter]
      @harry_potter.high_scorers.top_game_users(5).should == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter, @jerry_potter]
    end

    it "returns user around current user if users with equal score exists" do
      @dark_lord.high_scorers.game_users_around.should           == [@jack_sparrow_2, @jack_sparrow_1, @dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
      @tom_riddle.high_scorers.game_users_around.should          == [@tom_riddle, @ron_weasely, @harry_potter]
      @ivan_potter.high_scorers.game_users_around.should         == [@ron_weasely, @harry_potter, @ivan_potter, @jerry_potter, @jack_sparrow_2]
      @ron_weasely.high_scorers.game_users_around.should         == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter]
      @harry_potter.high_scorers.game_users_around.should        == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter, @jerry_potter]
      @jerry_potter.high_scorers.game_users_around.should        == [@harry_potter, @ivan_potter, @jerry_potter, @jack_sparrow_2, @jack_sparrow_1]
      @jack_sparrow_1.high_scorers.game_users_around.should      == [@jerry_potter, @jack_sparrow_2, @jack_sparrow_1, @dark_lord, @albus_dumbelldore]
      @jack_sparrow_2.high_scorers.game_users_around.should      == [@ivan_potter, @jerry_potter, @jack_sparrow_2, @jack_sparrow_1, @dark_lord]
      @albus_dumbelldore.high_scorers.game_users_around.should   == [@jack_sparrow_1, @dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
      @duglous_dumbelldore.high_scorers.game_users_around.should == [@dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
    end
  end

  context "Products" do
    before do
      Product.delete_all
      @cell  = Product.create!(name: 'cell', price: 122)
      @ring  = Product.create!(name: 'ring', price: 14)
      @shoe  = Product.create!(name: 'shoe', price: 235)
      @belt  = Product.create!(name: 'belt', price: 21)
      @watch = Product.create!(name: 'watch', price: 267)
      @food  = Product.create!(name: 'food', price: 9)
    end

    it "returns leaderboard objects" do
      @cell.costliest.should be_an_instance_of(Standings::Leaderboard)
      @ring.costliest.should be_an_instance_of(Standings::Leaderboard)
      @shoe.costliest.should be_an_instance_of(Standings::Leaderboard)
      @belt.costliest.should be_an_instance_of(Standings::Leaderboard)
      @watch.costliest.should be_an_instance_of(Standings::Leaderboard)
      @food.costliest.should be_an_instance_of(Standings::Leaderboard)
    end

    it "returns the current product rank" do
      @cell.costliest.current_product_rank.should  == 3
      @ring.costliest.current_product_rank.should  == 5
      @shoe.costliest.current_product_rank.should  == 2
      @belt.costliest.current_product_rank.should  == 4
      @watch.costliest.current_product_rank.should == 1
      @food.costliest.current_product_rank.should  == 6
    end

    it "returns the Top products" do
      @cell.costliest.top_products(2).should == [@watch, @shoe]
      @cell.costliest.top_products(3).should == [@watch, @shoe, @cell]
      @cell.costliest.top_products(4).should == [@watch, @shoe, @cell, @belt]
      @cell.costliest.top_products(5).should == [@watch, @shoe, @cell, @belt, @ring]
      @cell.costliest.top_products(6).should == [@watch, @shoe, @cell, @belt, @ring, @food]
      @cell.costliest.top_products(7).should == [@watch, @shoe, @cell, @belt, @ring, @food]
    end

    it "returns product around the current product" do
      @cell.costliest.products_around.should  == [@watch, @shoe, @cell, @belt, @ring, @food]
      @ring.costliest.products_around.should  == [@shoe, @cell, @belt, @ring, @food]
      @shoe.costliest.products_around.should  == [@watch, @shoe, @cell, @belt, @ring]
      @belt.costliest.products_around.should  == [@watch, @shoe, @cell, @belt, @ring, @food]
      @watch.costliest.products_around.should == [@watch, @shoe, @cell, @belt]
      @food.costliest.products_around.should  == [@cell, @belt, @ring, @food]
    end

    it "returns leaderboard for the current product" do
      @cell.costliest.to_hash.should == {
        current_product_rank: 3,
        products_around: [@watch, @shoe, @cell, @belt, @ring, @food],
        top_products: [@watch, @shoe, @cell]
      }

      @ring.costliest.to_hash(5).should == {
        current_product_rank: 5,
        products_around: [@shoe, @cell, @belt, @ring, @food],
        top_products: [@watch, @shoe, @cell, @belt, @ring]
      }

      @shoe.costliest.to_hash(2).should == {
        current_product_rank: 2,
        products_around: [@watch, @shoe, @cell, @belt, @ring],
        top_products: [@watch, @shoe]
      }

      @belt.costliest.to_hash.should == {
        current_product_rank: 4,
        products_around: [@watch, @shoe, @cell, @belt, @ring, @food],
        top_products: [@watch, @shoe, @cell]
      }

      @watch.costliest.to_hash(4).should == {
        current_product_rank: 1,
        products_around: [@watch, @shoe, @cell, @belt],
        top_products: [@watch, @shoe, @cell, @belt]
      }

      @food.costliest.to_hash(3).should == {
        current_product_rank: 6,
        products_around: [@cell, @belt, @ring, @food],
        top_products: [@watch, @shoe, @cell]
      }
    end
  end

  # Bad Configurations
  context "Bad Configuration Options" do
    before do
      @klass = Class.new do
        include ActiveModel::Model

        def self.name; "anonymus"; end

        attr_accessor :score

        extend Standings::ModelAdditions

        def self.column_names; ["score"]; end
      end
    end

    it "fails if column_name is blank" do
      @klass.class_eval do
        # Without primary column name
        leaderboard :bad_config, column_name: '',
                                 sort_order: ["name", "age DESC"],
                                 around_limit: 2
      end

      lambda {
        @klass.new(score: 5).bad_config
      }.should raise_error(Standings::Error::InvalidColumnName)
    end

    it "fails if column_name is not a database column" do
      @klass.class_eval do
        leaderboard :bad_config, column_name: :im_not_in_db,
                                 sort_order: ["name", "age DESC"],
                                 around_limit: 2
      end

      lambda {
        @klass.new(score: 5).bad_config
      }.should raise_error(Standings::Error::InvalidColumnName)
    end

    it "fails if sort_order is not an array" do
      @klass.class_eval do
        # Invalid sort order
        leaderboard :bad_config, column_name: :score,
                                 sort_order: "name",
                                 around_limit: 2
      end

      lambda {
        @klass.new(score: 5).bad_config
      }.should raise_error(Standings::Error::InvalidSortOrder)
    end

    it "fails if around_limit is zero or less" do
      @klass.class_eval do
        # Invalid around limit
        leaderboard :bad_config, column_name: :score,
                                 sort_order: ["name", "age DESC"],
                                 around_limit: [0, -1, -2].sample
      end

      lambda {
        @klass.new(score: 5).bad_config
      }.should raise_error(Standings::Error::InvalidAroundLimit)
    end
  end

  describe ".leaderboard" do
    before do
      Developer.delete_all
      @aaron = Developer.create!(name: 'Aaron Patterson', ruby_gems_created: 100, total_experience: 15)
      @corey = Developer.create!(name: 'Corey Haines', ruby_gems_created: 90, total_experience: 20)
      @jim   = Developer.create!(name: 'Jim Weirich', ruby_gems_created: 50, total_experience: 30)
    end

    it "returns leaderboard objects" do
      @aaron.ruby_heroes.should be_an_instance_of(Standings::Leaderboard)
      @corey.ruby_heroes.should be_an_instance_of(Standings::Leaderboard)
      @jim.ruby_heroes.should be_an_instance_of(Standings::Leaderboard)
    end

    context "#current_developer_rank" do
      it "returns current rank" do
        @aaron.ruby_heroes.current_developer_rank == 1
        @corey.ruby_heroes.current_developer_rank == 2
        @jim.ruby_heroes.current_developer_rank   == 3
      end
    end

    context "#developers_around" do
      it "returns developers around" do
        @aaron.ruby_heroes.developers_around == [ @aaron, @corey, @jim ]
        @corey.ruby_heroes.developers_around == [ @aaron, @corey, @jim ]
        @jim.ruby_heroes.developers_around   == [ @aaron, @corey, @jim ]
      end
    end

    context "#top_developers" do
      it "returns top developers" do
        @aaron.ruby_heroes.top_developers    == [ @aaron, @corey, @jim ]
        @corey.ruby_heroes.top_developers(2) == [ @aaron, @corey ]
        @jim.ruby_heroes.top_developers(1)   == [ @aaron ]
      end
    end

    context "#to_hash method" do
      it "returns leaderboard hash" do
        @aaron.ruby_heroes.to_hash.should == {
          current_developer_rank: 1,
          developers_around: [ @aaron, @corey, @jim ],
          top_developers: [ @aaron, @corey, @jim ]
        }
        @corey.ruby_heroes.to_hash(1).should == {
          current_developer_rank: 2,
          developers_around: [ @aaron, @corey, @jim ],
          top_developers: [ @aaron ]
        }
        @jim.ruby_heroes.to_hash(2).should == {
          current_developer_rank: 3,
          developers_around: [ @aaron, @corey, @jim ],
          top_developers: [ @aaron, @corey ]
        }
      end

      it "returns leaderboard hash" do
        @aaron.veterans.to_hash(2).should == {
          current_developer_rank: 3,
          developers_around: [ @corey, @aaron ],
          top_developers: [ @jim, @corey ]
        }
        @corey.veterans.to_hash.should == {
          current_developer_rank: 2,
          developers_around: [ @jim, @corey, @aaron ],
          top_developers: [ @jim, @corey, @aaron ]
        }
        @jim.veterans.to_hash(1).should == {
          current_developer_rank: 1,
          developers_around: [ @jim, @corey ],
          top_developers: [ @jim ]
        }
      end
    end
  end

end
