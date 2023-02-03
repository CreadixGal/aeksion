module Cost
  extend ActiveSupport::Concern

  included do
    has_many :prices, as: :cost
  end
end