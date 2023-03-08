class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    has_many :posts, dependent: :destroy
    has_many :post_comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :customer_rooms
    has_many :chats

    has_one_attached :profile_image
     
    has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
    has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy 

 def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
  end
  profile_image.variant(resize_to_limit: [width, height]).processed
 end


 # フォローをした、されたの関係
has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

# 一覧画面で使う
has_many :followings, through: :relationships, source: :followed
has_many :followers, through: :reverse_of_relationships, source: :follower

# フォローしたときの処理
def follow(customer_id)
  relationships.create(followed_id: customer_id)
end
# フォローを外すときの処理
def unfollow(customer_id)
  relationships.find_by(followed_id: customer_id).destroy
end
# フォローしているか判定
def following?(customer)
  followings.include?(customer)
end


def create_notification_follow!(current_customer)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ",current_customer.id, id, 'follow'])
    if temp.blank?
      notification = current_customer.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
end

end
