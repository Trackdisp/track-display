ActiveAdmin.register Brand do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    tag_column :channel
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :channel, &:channel_text
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :channel, &:channel_text
    end
    f.actions
  end
end
