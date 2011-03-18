class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|

      t.references :channel
      t.integer :parent_branch_id
      t.integer :root_message_id
      t.timestamps
    end
  end

  def self.down
    drop_table :branches
  end
end
