class CreatePeopleSecretsantas < ActiveRecord::Migration
  def change
    create_table :people_secretsantas do |t|
      t.integer :year, null: false
      t.references :person, index: true, foreign_key: true
      t.integer :santa_id
      t.integer :partner_id
      t.integer :previous_santa_id

      t.timestamps null: false
    end
    add_index :people_secretsantas, :santa_id
    add_index :people_secretsantas, :partner_id
    add_index :people_secretsantas, :previous_santa_id
  end
end
