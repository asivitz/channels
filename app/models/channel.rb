class Channel < ActiveRecord::Base
      validates_presence_of :name
      has_many :messages, :dependent => :destroy
      has_and_belongs_to_many :users
end
