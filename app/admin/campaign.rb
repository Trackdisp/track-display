ActiveAdmin.register Campaign do
  permit_params :name, :company_id, :start_date, :end_date

  filter :name
  filter :company

  index do
    selectable_column
    id_column
    column :name
    column :company
    column :start_date
    column :end_date
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :company
      row :start_date
      row :end_date
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :company
      f.input :start_date, as: :date_picker
      f.input :end_date, as: :date_picker
    end
    f.actions
  end
end
