class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id


      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
