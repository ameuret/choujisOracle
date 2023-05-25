Sequel.migration do
  up do
    create_table :characters do
      primary_key :id
      String :name
      String :element
      String :weapon
      Integer :rarity
      String :statsURL
    end
  end

  down do
    drop_table :characters
  end
end
