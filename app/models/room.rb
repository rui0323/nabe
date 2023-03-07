class Room < ApplicationRecord
  has_many :customer_rooms
  has_many :chats

  belongs_to :customer, optional: true
  belongs_to :room, optional: true
end
