class AddManyFieldsToEvents < ActiveRecord::Migration
  def self.up
		add_column :events, :end_date, :date
		add_column :events, :price, :string
		add_column :events, :website, :string
		add_column :events, :contact_email, :string
		add_column :events, :contact_phone, :string
		add_column :events, :image, :string
		add_column :events, :guests, :string
		add_column :events, :demographic, :string
		add_column :events, :sub_category, :string
		add_column :events, :rsvp, :integer
  end

  def self.down
		remove_column :events, :end_date
		remove_column :events, :price
		remove_column :events, :website
		remove_column :events, :contact_email
		remove_column :events, :contact_phone
		remove_column :events, :image
		remove_column :events, :guests
		remove_column :events, :demographic
		remove_column :events, :sub_category
		remove_column :events, :rsvp
  end
end
