require 'digest/sha1'
require File.join(File.dirname(__FILE__), '..', '..', "lib", "authenticated_system", "authenticated_dependencies") rescue nil

class User
  include DataMapper::Resource
  include AuthenticatedSystem::Model
  
  attr_accessor :password, :password_confirmation
  
  property :id,                         Serial
  property :login,                      String
  property :email,                      String
  property :crypted_password,           String
  property :salt,                       String
  property :remember_token_expires_at,  DateTime
  property :remember_token,             String
  property :created_at,                 DateTime
  property :updated_at,                 DateTime
  
  #validates_length_of         :login,                   :within => 3..40
  #validates_uniqueness_of     :login
  #validates_presence_of       :email
  ## validates_format_of         :email,                   :as => :email_address
  #validates_length_of         :email,                   :within => 3..100
  #validates_uniqueness_of     :email
  #validates_presence_of       :password,                :if => proc {password_required?}
  #validates_presence_of       :password_confirmation,   :if => proc {password_required?}
  #validates_length_of         :password,                :within => 4..40, :if => proc {password_required?}
  #validates_confirmation_of   :password,                :groups => :create
    
  before :save, :encrypt_password
  
  def login=(value)
    @login = value.downcase unless value.nil?
  end
    


  
end