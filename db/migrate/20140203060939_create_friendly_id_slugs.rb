class CreateFriendlyIdSlugs < ActiveRecord::Migration

  def up
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           null: false
      t.integer  :sluggable_id,   null: false
      t.string   :sluggable_type, limit: 40
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, :sluggable_type
  end

  def down
    drop_table :friendly_id_slugs
  end
end
