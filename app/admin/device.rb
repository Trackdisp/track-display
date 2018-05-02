ActiveAdmin.register Device do
  permit_params :name, :serial, :company_id

  filter :company
  filter :name
  filter :serial

  index do
    selectable_column
    id_column
    column :company
    column :name
    column :serial
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :company
      f.input :name
      f.input :serial
    end
    f.actions
  end
end
