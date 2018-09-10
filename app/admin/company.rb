ActiveAdmin.register Company do
  permit_params :name, :logo

  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :company
      row :created_at
      row :logo do |company|
        image_tag company.logo.variant(resize: '100x100') if company.logo.attached?
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :logo, as: :file
    end
    f.actions
  end
end
