Sequel.migration do
  up do
    create_table :stats do
      primary_key :id
      foreign_key :character_id, :characters
      Integer :level
      Integer :hp
      Integer :atk
      Integer :def
      Float :critRate
      Float :critDmg
      Float :bonusCritDmg
    end
  end

  down do
    drop_table :stats
  end
end
