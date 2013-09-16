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
      @product_1 = Product.create!(name: 'cell', price: 122)
      @product_2 = Product.create!(name: 'ring', price: 14)
      @product_3 = Product.create!(name: 'shooe', price: 235)
      @product_4 = Product.create!(name: 'belt', price: 21)
      @product_5 = Product.create!(name: 'watch', price: 267)
      @product_6 = Product.create!(name: 'food', price: 9)
    end

    it "returns the current product rank" do
      @product_1.current_product_rank.should == 3
      @product_2.current_product_rank.should == 5
      @product_3.current_product_rank.should == 2
      @product_4.current_product_rank.should == 4
      @product_5.current_product_rank.should == 1
      @product_6.current_product_rank.should == 6
    end

    it "returns the Top products" do
      Product.top_products(2).should == [@product_5, @product_3]
      Product.top_products(3).should == [@product_5, @product_3, @product_1]
      Product.top_products(4).should == [@product_5, @product_3, @product_1, @product_4]
      Product.top_products(5).should == [@product_5, @product_3, @product_1, @product_4, @product_2]
      Product.top_products(6).should == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
      Product.top_products(7).should == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
    end

    it "returns product around the current product" do
      @product_1.products_around.should == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
      @product_2.products_around.should == [@product_3, @product_1, @product_4, @product_2, @product_6]
      @product_3.products_around.should == [@product_5, @product_3, @product_1, @product_4, @product_2]
      @product_4.products_around.should == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
      @product_5.products_around.should == [@product_5, @product_3, @product_1, @product_4]
      @product_6.products_around.should == [@product_1, @product_4, @product_2, @product_6]
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
