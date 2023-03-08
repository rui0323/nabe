class Post < ApplicationRecord
   has_one_attached :image
   belongs_to :customer
   has_many :post_comments, dependent: :destroy
   has_many :favorites, dependent: :destroy
   has_many :notifications, dependent: :destroy

   validates :title, presence: true
   validates :body, presence: true
   validates :image, presence: true

   def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
   end

   def get_image
    if image.attached?
      image
    else
      'no_image.jpg'
    end
   end


   def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
   end



   def create_notification_by(current_customer)
       notification = current_customer.active_notifications.new(
          post_id: id,
          visited_id: customer_id,
          action: "like"
        )
        notification.save if notification.valid?
   end

   def create_notification_comment!(current_customer, post_comment_id)
        # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
        temp_ids = PostComment.select(:customer_id).where(post_id: id).where.not(customer_id: current_customer.id).distinct
        temp_ids.each do |temp_id|
            save_notification_comment!(current_customer, post_comment_id, temp_id['customer_id'])
        end
    	# まだ誰もコメントしていない場合は、投稿者に通知を送る
        save_notification_comment!(current_customer, post_comment_id, customer_id) if temp_ids.blank?
   end

   def save_notification_comment!(current_customer, post_comment_id, visited_id)
        # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
        notification = current_customer.active_notifications.new(
          post_id: id,
          post_comment_id: comment_id,
          visited_id: visited_id,
          action: 'comment'
        )
        # 自分の投稿に対するコメントの場合は、通知済みとする
        if notification.visiter_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
   end

end
