require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Users do

  include UserSpecHelper

  before(:each) do
    User.clear_database_table
    @quentin = User.create(valid_user_hash.with(:login => "quentin", :password => "test", :password_confirmation => "test", :email => 'quentin@test.com'))
  end

  it 'allows signup' do
    lambda do
      controller = create_user
      controller.should redirect
    end.should change(User, :count).by(1)
  end

  it 'requires login on signup' do
    lambda do
      controller = create_user(:login => nil)
      controller.assigns(:user).errors.on(:login).should_not be_nil
      controller.should respond_successfully
    end.should_not change(User, :count)
  end
   
  it 'requires password on signup' do
    lambda do
      controller = create_user(:password => nil)
      controller.assigns(:user).errors.on(:password).should_not be_nil
      controller.should respond_successfully
    end.should_not change(User, :count)
  end
    
  it 'requires password confirmation on signup' do
    lambda do
      controller = create_user(:password_confirmation => nil)
      controller.assigns(:user).errors.on(:password_confirmation).should_not be_nil
      controller.should respond_successfully
    end.should_not change(User, :count)
  end
  
  it 'requires email on signup' do
    lambda do
      controller = create_user(:email => nil)
      controller.assigns(:user).errors.on(:email).should_not be_nil
      controller.should respond_successfully
    end.should_not change(User, :count)
  end

  def create_user(options = {})
    # post "/users", :user => valid_user_hash.merge(options)
    dispatch_to( Users, :create, :user => valid_user_hash.merge(options) ) { |request|
      request.stub!(:current_user).and_return(@quentin)
    }
  end
end