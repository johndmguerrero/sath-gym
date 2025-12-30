class AddFieldStatusFaceScanned < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.boolean :face_scan, default: false
    end
  end
end
