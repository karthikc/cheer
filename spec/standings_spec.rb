require 'spec_helper'

describe Standings do
  before(:each) do
  end

  def create_game_users!
    @jack_sparrow = GameUser.create!(name: 'Jack Sparrow', score: 12)
    @harry_potter = GameUser.create!(name: 'Harry Potter', score: 14)
    @ron_weasely = GameUser.create!(name: 'Ron Weasely', score: 23)
    @albus_dumbelldore = GameUser.create!(name: 'Albus Dumbelldore', score: 2)
    @tom_riddle = GameUser.create!(name: 'Tom Riddle', score: 25)
    @dark_lord = GameUser.create!(name: 'Dark Lord', score: 11)
  end

  def create_game_users_with_equal_score!
    @jack_sparrow_1 = GameUser.create!(name: 'Jack Sparrow', score: 12, age: 22)
    @jack_sparrow_2 = GameUser.create!(name: 'Jack Sparrow', score: 12, age: 23)
    @harry_potter = GameUser.create!(name: 'Harry Potter', score: 14)
    @ivan_potter = GameUser.create!(name: 'Ivan Potter', score: 14)
    @jerry_potter = GameUser.create!(name: 'Jerry Potter', score: 14)
    @ron_weasely = GameUser.create!(name: 'Ron Weasely', score: 23)
    @albus_dumbelldore = GameUser.create!(name: 'Albus Dumbelldore', score: 2)
    @duglous_dumbelldore = GameUser.create!(name: 'Duglous Dumbelldore', score: 2)
    @tom_riddle = GameUser.create!(name: 'Tom Riddle', score: 25)
    @dark_lord = GameUser.create!(name: 'Dark Lord', score: 11)
  end
  
  def create_products!
    @product_1 = Product.create!(name: 'cell', price: 122)
    @product_2 = Product.create!(name: 'ring', price: 14)
    @product_3 = Product.create!(name: 'shooe', price: 235)
    @product_4 = Product.create!(name: 'belt', price: 21)
    @product_5 = Product.create!(name: 'watch', price: 267)
    @product_6 = Product.create!(name: 'food', price: 9)
  end

  def create_students_with_equal_score!
    @subrat = Student.create!(name: 'Subrat Behera', score: 23)
    @rakesh = Student.create!(name: 'Rakesh Verma', score: 22)
    @girish = Student.create!(name: 'Girish Kumar', score: 21)
    @nitin = Student.create!(name: 'Nitin Misra', score: 22)
    @prateeth = Student.create!(name: 'Prateeth S', score: 20)
    @bhanu = Student.create!(name: 'Bhanu Chander', score: 19)
  end

  it "should return the current user rank" do
    create_game_users!
    @jack_sparrow.current_game_user_rank.should be == 4
    @harry_potter.current_game_user_rank.should be == 3
    @ron_weasely.current_game_user_rank.should be == 2
    @albus_dumbelldore.current_game_user_rank.should be == 6
    @tom_riddle.current_game_user_rank.should be == 1
    @dark_lord.current_game_user_rank.should be == 5
  end

  it "should return the current user rank if users with equal score exists" do
    create_game_users_with_equal_score!
    @jack_sparrow_1.current_game_user_rank.should be == 7
    @jack_sparrow_2.current_game_user_rank.should be == 6
    @harry_potter.current_game_user_rank.should be == 3
    @ivan_potter.current_game_user_rank.should be == 4
    @jerry_potter.current_game_user_rank.should be == 5
    @ron_weasely.current_game_user_rank.should be == 2
    @albus_dumbelldore.current_game_user_rank.should be == 9
    @duglous_dumbelldore.current_game_user_rank.should be == 10
    @tom_riddle.current_game_user_rank.should be == 1
    @dark_lord.current_game_user_rank.should be == 8
  end

  it "should return the current student rank if students with equal score exists" do
    # For equal score students sorting should be done oon the basis of id,
    # since Student model doesn't define sort_columns array.
    create_students_with_equal_score!
    @subrat.current_student_rank.should be == 1
    @rakesh.current_student_rank.should be == 2
    @girish.current_student_rank.should be == 4
    @nitin.current_student_rank.should be == 3
    @prateeth.current_student_rank.should be == 5
    @bhanu.current_student_rank.should be == 6
  end

  it "should return the top rank users" do
    create_game_users!
    GameUser.top_game_users(2).should be == [@tom_riddle, @ron_weasely]
    GameUser.top_game_users(5).should be == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow, @dark_lord]
    GameUser.top_game_users(4).should be == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow]
    GameUser.top_game_users(1).should be == [@tom_riddle]
    GameUser.top_game_users.should be == [@tom_riddle, @ron_weasely, @harry_potter]
  end

  it "should return the top rank users if equal score users exists" do
    create_game_users_with_equal_score!
    GameUser.top_game_users(2).should be == [@tom_riddle, @ron_weasely]
    GameUser.top_game_users(5).should be == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter, @jerry_potter]
    GameUser.top_game_users(4).should be == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter]
    GameUser.top_game_users(1).should be == [@tom_riddle]
    GameUser.top_game_users.should be == [@tom_riddle, @ron_weasely, @harry_potter]
  end

  it "return user around to current user according score descending" do
    create_game_users!
    @harry_potter.game_users_around.should be == [@tom_riddle, @ron_weasely, @harry_potter, @jack_sparrow, @dark_lord]
    @tom_riddle.game_users_around.should be == [@tom_riddle, @ron_weasely, @harry_potter]
    @albus_dumbelldore.game_users_around.should be == [@jack_sparrow, @dark_lord, @albus_dumbelldore]
  end

  it "should return user around current user if users with equal score exists" do
    create_game_users_with_equal_score!
    @jack_sparrow_1.game_users_around.should be == [@jerry_potter, @jack_sparrow_2, @jack_sparrow_1, @dark_lord, @albus_dumbelldore]
    @jack_sparrow_2.game_users_around.should be == [@ivan_potter, @jerry_potter, @jack_sparrow_2, @jack_sparrow_1, @dark_lord]
    @harry_potter.game_users_around.should be == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter, @jerry_potter]
    @ivan_potter.game_users_around.should be == [@ron_weasely, @harry_potter, @ivan_potter, @jerry_potter, @jack_sparrow_2]
    @jerry_potter.game_users_around.should be == [@harry_potter, @ivan_potter, @jerry_potter, @jack_sparrow_2, @jack_sparrow_1]
    @ron_weasely.game_users_around.should be == [@tom_riddle, @ron_weasely, @harry_potter, @ivan_potter]
    @albus_dumbelldore.game_users_around.should be == [@jack_sparrow_1, @dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
    @duglous_dumbelldore.game_users_around.should be == [@dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
    @tom_riddle.game_users_around.should be == [@tom_riddle, @ron_weasely, @harry_potter]
    @dark_lord.game_users_around.should be == [@jack_sparrow_2, @jack_sparrow_1, @dark_lord, @albus_dumbelldore, @duglous_dumbelldore]
  end

  it "should return the current product rank" do
    create_products!
    @product_1.current_product_rank.should be == 3
    @product_2.current_product_rank.should be == 5
    @product_3.current_product_rank.should be == 2
    @product_4.current_product_rank.should be == 4
    @product_5.current_product_rank.should be == 1
    @product_6.current_product_rank.should be == 6
  end
  
  it "should return the Top products" do
    create_products!
    Product.top_products(2).should be == [@product_5, @product_3]
    Product.top_products(3).should be == [@product_5, @product_3, @product_1]
    Product.top_products(4).should be == [@product_5, @product_3, @product_1, @product_4]
    Product.top_products(5).should be == [@product_5, @product_3, @product_1, @product_4, @product_2]
    Product.top_products(6).should be == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
    Product.top_products(7).should be == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
  end
  
  it "should return product around the current product" do
    create_products!
    @product_1.products_around.should be == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
    @product_2.products_around.should be == [@product_3, @product_1, @product_4, @product_2, @product_6]
    @product_3.products_around.should be == [@product_5, @product_3, @product_1, @product_4, @product_2]
    @product_4.products_around.should be == [@product_5, @product_3, @product_1, @product_4, @product_2, @product_6]
    @product_5.products_around.should be == [@product_5, @product_3, @product_1, @product_4]
    @product_6.products_around.should be == [@product_1, @product_4, @product_2, @product_6]
  end

end
