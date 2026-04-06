class Item < ApplicationRecord

  searchable do
    text :title, :text, :sn, :brand, :scale, :dateval, :sellprice, :selldate
  end

  validates :title, presence: true,
                    length: { minimum: 5 }

  has_one_attached :trainimage

  def trainimage_thumb
    trainimage.variant(resize_to_limit: [130, 100]).processed if trainimage.attached?
  end

  def trainimage_medium
    trainimage.variant(resize_to_limit: [390, 300]).processed if trainimage.attached?
  end

  def trainimage_original
    trainimage.variant(resize_to_limit: [780, 600]).processed if trainimage.attached?
  end

end

