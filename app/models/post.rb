class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  def as_json(options = {})
    if options[:index]
      {
        id: id,
        title: title,
        content: content,
        created_at: created_at,
        user: {
          id: user.id,
          full_name: user.full_name
        }
      }
    else
      super
    end
  end
end
