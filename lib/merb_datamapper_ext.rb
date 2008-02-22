class DataMapperSession < DataMapper::Base
  property :session_id, :string, :length => 255, :lazy => false, :key => true, :serial => true
end