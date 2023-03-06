class Room < ApplicationRecord
  has_many :customer_rooms
  has_many :chats

  belongs_to :customer
  belongs_to :room
end
