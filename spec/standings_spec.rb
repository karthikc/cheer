require 'spec_helper'

describe Standings do
  context "Students With Equal Score" do
    before do
      @subrat   = Student.create!(name: 'Subrat Behera', score: 23)
      @rakesh   = Student.create!(name: 'Rakesh Verma', score: 22)
      @girish   = Student.create!(name: 'Girish Kumar', score: 21)
      @nitin    = Student.create!(name: 'Nitin Misra', score: 22)
      @bhanu    = Student.create!(name: 'Bhanu Chander', score: 19)
      @prateeth = Student.create!(name: 'Prateeth S', score: 20)
    end

    it "returns the current student rank if students with equal score exists" do
      # For students with equal scores, sorting should be done on the basis of id,
      # since the Student model doesn't define sort_order array.

      @bhanu.current_student_rank.should    == 6
      @nitin.current_student_rank.should    == 3
      @subrat.current_student_rank.should   == 1
      @rakesh.current_student_rank.should   == 2
      @girish.current_student_rank.should   == 4
      @prateeth.current_student_rank.should == 5
    end
  end

  context "GameUsers" do
    before do
      @dark_lord         = GameUser.create!(name: 'Dark Lord', score: 11)
      @tom_riddle        = GameUser.create!(name: 'Tom Riddle', score: 25)
      @ron_weasely       = GameUser.create!(name: 'Ron Weasely', score: 23)
      @harry_potter      = GameUser.create!(name: 'Harry Potter', score: 14)
      @jack_sparrow      = GameUser.create!(name: 'Jack Sparrow', score: 12)
      @albus_dumbelldore = GameUser.create!(name: 'Albus Dumbelldore', score: 2)
    end

    it "returns the current user rank" do
      @dark_lord.current_game_user_rank.should         == 5
      @tom_riddle.current_game_user_rank.should        == 1
      @ron_weasely.current_game_user_rank.should       == 2
      @jack_sparrow.current_game_user_rank.should      == 4
      @harry_potter.current_game_user_rank.should      == 3
      @albus_dumbelldore.current_game_user_rank.should == 6
    end

    it "returns the top rank users" do
      GameUser.top_game_users.should    == [@tom_riddle, @ron_weasely, @harry_potter]
      GameUser.top_game_users(2).should == [@tom_riddle, @ron_weasely]
      GameUser.top_game_users(5).should == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow, @dark_lord]
      GameUser.top_game_users(4).should == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow]
      GameUser.top_game_users(1).should == [@tom_riddle]
    end

    it "returns user around to current user according score descending" do
      @tom_riddle.game_users_around.should        == [@tom_riddle, @ron_weasely, @harry_potter]
      @harry_potter.game_users_around.should      == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow, @dark_lord]
      @albus_dumbelldore.game_users_around.should == [@jack_sparrow, @dark_lord, @albus_dumbelldore]
    end
  end

  context "GameUsers With Equal Score" do
    before do
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
      @dark_lord.current_game_user_rank.should           == 8
      @tom_riddle.current_game_user_rank.should          == 1
      @ivan_potter.current_game_user_rank.should         == 4
      @ron_weasely.current_game_user_rank.should         == 2
      @harry_potter.current_game_user_rank.should        == 3
      @jerry_potter.current_game_user_rank.should        == 5
      @jack_sparrow_1.current_game_user_rank.should      == 7
      @jack_sparrow_2.current_game_user_rank.should      == 6
      @albus_dumbelldore.current_game_user_rank.should   == 9
      @duglous_dumbelldore.current_game_user_rank.should == 10
    end

    it "returns the top rank users if equal score users exists" do
      GameUser.top_game_users.should    == [@tom_riddle, @ron_weasely, @harry_potter]
      GameUser.top_game_users(1).should == [@tom_riddle]
      GameUser.top_game_users(2).should == [@tom_riddle, @ron_weasely]
      GameUser.top_game_users(4).should == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter]
      GameUser.top_game_users(5).should == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter, @jerry_potter]
    end

    it "returns user around current user if users with equal score exists" do
      @dark_lord.game_users_around.should           == [@jack_sparrow_2, @jack_sparrow_1, @dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
      @tom_riddle.game_users_around.should          == [@tom_riddle, @ron_weasely, @harry_potter]
      @ivan_potter.game_users_around.should         == [@ron_weasely, @harry_potter, @ivan_potter, @jerry_potter, @jack_sparrow_2]
      @ron_weasely.game_users_around.should         == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter]
      @harry_potter.game_users_around.should        == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter, @jerry_potter]
      @jerry_potter.game_users_around.should        == [@harry_potter, @ivan_potter, @jerry_potter, @jack_sparrow_2, @jack_sparrow_1]
      @jack_sparrow_1.game_users_around.should      == [@jerry_potter, @jack_sparrow_2, @jack_sparrow_1, @dark_lord, @albus_dumbelldore]
      @jack_sparrow_2.game_users_around.should      == [@ivan_potter, @jerry_potter, @jack_sparrow_2, @jack_sparrow_1, @dark_lord]
      @albus_dumbelldore.game_users_around.should   == [@jack_sparrow_1, @dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
      @duglous_dumbelldore.game_users_around.should == [@dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
    end
  end

  context "Products" do
    before do
      @cell  = Product.create!(name: 'cell', price: 122)
      @ring  = Product.create!(name: 'ring', price: 14)
      @shoe  = Product.create!(name: 'shoe', price: 235)
      @belt  = Product.create!(name: 'belt', price: 21)
      @watch = Product.create!(name: 'watch', price: 267)
      @food  = Product.create!(name: 'food', price: 9)
    end

    it "returns the current product rank" do
      @cell.current_product_rank.should  == 3
      @ring.current_product_rank.should  == 5
      @shoe.current_product_rank.should  == 2
      @belt.current_product_rank.should  == 4
      @watch.current_product_rank.should == 1
      @food.current_product_rank.should  == 6
    end

    it "returns the Top products" do
      Product.top_products(2).should == [@watch, @shoe]
      Product.top_products(3).should == [@watch, @shoe, @cell]
      Product.top_products(4).should == [@watch, @shoe, @cell, @belt]
      Product.top_products(5).should == [@watch, @shoe, @cell, @belt, @ring]
      Product.top_products(6).should == [@watch, @shoe, @cell, @belt, @ring, @food]
      Product.top_products(7).should == [@watch, @shoe, @cell, @belt, @ring, @food]
    end

    it "returns product around the current product" do
      @cell.products_around.should  == [@watch, @shoe, @cell, @belt, @ring, @food]
      @ring.products_around.should  == [@shoe, @cell, @belt, @ring, @food]
      @shoe.products_around.should  == [@watch, @shoe, @cell, @belt, @ring]
      @belt.products_around.should  == [@watch, @shoe, @cell, @belt, @ring, @food]
      @watch.products_around.should == [@watch, @shoe, @cell, @belt]
      @food.products_around.should  == [@cell, @belt, @ring, @food]
    end

    it "returns leaderboard for the current product" do
      @cell.leaderboard.should  == {
        current_rank: @cell.current_product_rank,
        rank_around: @cell.products_around,
        top_products: Product.top_products
      }

      @ring.leaderboard(5).should  == {
        current_rank: @ring.current_product_rank,
        rank_around: @ring.products_around,
        top_products: Product.top_products(5)
      }

      @shoe.leaderboard(2).should  == {
        current_rank: @shoe.current_product_rank,
        rank_around: @shoe.products_around,
        top_products: Product.top_products(2)
      }

      @belt.leaderboard.should  == {
        current_rank: @belt.current_product_rank,
        rank_around: @belt.products_around,
        top_products: Product.top_products
      }

      @watch.leaderboard(4).should  == {
        current_rank: @watch.current_product_rank,
        rank_around: @watch.products_around,
        top_products: Product.top_products(4)
      }

      @food.leaderboard(3).should  == {
        current_rank: @food.current_product_rank,
        rank_around: @food.products_around,
        top_products: Product.top_products
      }
    end
  end

  # Bad Configurations
  context "Bad Configuration Options" do
    it "fails if primary column_name is absent" do
      lambda do
        Class.new(ActiveRecord::Base) do
          # Without primary column name
          rank_by sort_order: ["name", "age DESC"], around_limit: 2
        end
      end.should raise_error(Error::InvalidColumnName)
    end

    it "fails if sort_order is not an array" do
      lambda do
        Class.new(ActiveRecord::Base) do
          # Invalid sort order
          rank_by :score, sort_order: "name", around_limit: 2
        end
      end.should raise_error(Error::InvalidSortOrder)
    end

    it "fails if around_limit is zero or less" do
      lambda do
        Class.new(ActiveRecord::Base) do
          # Invalid around limit
          rank_by :score, sort_order: ["name", "age DESC"], around_limit: [0, -1, -2].sample
        end
      end.should raise_error(Error::InvalidAroundLimit)
    end
  end

  describe "#method_missing" do
    it "doesn't define instance methods unless any of the standing method is called" do
      product = Product.create!(name: 'cell', price: 122)

      Product.any_instance.should_not_receive(:define_instance_methods)
      lambda { product.unknown_method }.should raise_error(NoMethodError)
    end
  end
end
