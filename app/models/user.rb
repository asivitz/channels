require 'digest/sha1'

class User < ActiveRecord::Base
    validates_presence_of :alias, :password, :password_confirmation, :salt
    validates_length_of :alias, :within => 3..20
    validates_length_of :password, :within => 5..30
    validates_uniqueness_of :alias
    validates_confirmation_of :password

    has_many :channelconfigs
    has_many :channels, :through => :channelconfigs

    attr_protected :id, :salt
    attr_accessor :password, :password_confirmation


    def self.random_string(len)
        # generate a random password consisting of strings and digits
        chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
        newpass = ""
        1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
        return newpass
    end

    def password=(pass)
        @password=pass
        self.salt = User.random_string(10) if !self.salt?
        self.hashed_password = User.encrypt(@password, self.salt)
    end

    def self.encrypt(pass, salt)
        Digest::SHA1.hexdigest(pass+salt)
    end

    def self.authenticate(login, pass)
        u=where("alias = ?", login).first
        return nil if u.nil?
        return u if User.encrypt(pass, u.salt)==u.hashed_password
        nil
    end  
    
    def unread_messages channel_id
        config = Channelconfig.where(:channel_id => channel_id, :user_id => self.id).first
        last_checked = config.last_checked
        Message.where("channel_id = ? AND poster <> ?", channel_id, self.alias).since(last_checked)
    end
end
