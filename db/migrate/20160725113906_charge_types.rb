
class ChargeTypes < ActiveRecord::Migration

  def change
    rename_table :additional_charge_types, :charge_types
    add_column :charge_types, :type, :string
    add_column :charge_types, :charge_event, :string

    rename_column :charge_types, :additional_charge_type_target_id, :charge_type_target_id
    rename_column :charge_types, :additional_charge_type_target_type, :charge_type_target_type

    add_column :charge_types, :deleted_at, :timestamp, null: true if !ChargeType.column_names.include?('deleted_at')

    ChargeType.update_all("type = 'AdditionalChargeType'")
  end
end