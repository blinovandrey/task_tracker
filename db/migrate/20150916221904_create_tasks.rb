class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :creator_id
      t.integer :state
      t.integer :project_id

      t.timestamps
    end
  end
end
