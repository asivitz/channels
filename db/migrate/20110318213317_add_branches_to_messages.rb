class AddBranchesToMessages < ActiveRecord::Migration
  def self.up
      add_column :messages, :branch_id, :integer
  end

  def self.down
      remove_column :messages, :branch_id
  end
end
