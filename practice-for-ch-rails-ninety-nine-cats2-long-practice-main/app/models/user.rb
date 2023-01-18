# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    before_validation :ensure_session_token

    has_many :cats,
        foreign_key: :owner_id,
        inverse_of: :owner,
        class_name: :Cat

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password=password
    end
    
    def is_password?(password)
        #turn string into object
        password_object = BCrypt::Password.new(self.password_digest)
        #is_password? Is a crypto method
        password_object.is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            return user
        else
            return nil
        end
    end


    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    private
    def generate_unique_session_token
        loop do
            session_token = SecureRandom::urlsafe_base64
            return session_token unless User.exists?(session_token: session_token)
        end
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

end
