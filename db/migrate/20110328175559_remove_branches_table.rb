class RemoveBranchesTable < ActiveRecord::Migration
  def self.up
      drop_table :branches
      add_column :messages, :has_branch, :boolean
  end

  def self.down
  end
end
