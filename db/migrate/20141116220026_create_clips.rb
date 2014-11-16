class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.string :video_id
      t.integer :start_time
      t.integer :end_time

      t.timestamps
    end
  end
end
