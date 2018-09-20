class CreateResultlists < ActiveRecord::Migration[5.2]
  def change
    create_table :resultlists, option: 'ENGINE=InnoDB AUTO_INCREMENT=894 DEFAULT CHARSET=utf8' do |t|
      t.string :title
      t.string :url, limit: 512
      t.string :comment, limit: 512

      t.timestamps
    end
  end
end
