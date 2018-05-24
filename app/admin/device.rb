ActiveAdmin.register Device do
  belongs_to :campaign, optional: true, finder: :find_by_slug
  permit_params :name, :serial, :company_id, :campaign_id

  filter :campaign
  filter :name
  filter :serial

  index do
    selectable_column
    id_column
    column :campaign
    column :name
    column :serial
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :campaign
      f.input :name
      f.input :serial
    end
    f.actions
  end
end
