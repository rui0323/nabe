class Post < ApplicationRecord
   has_one_attached :image
   belongs_to :customer
   has_many :post_comments, dependent: :destroy
   has_many :favorites, dependent: :destroy

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

end
