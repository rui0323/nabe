class Chat < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :room, optional: true
end
