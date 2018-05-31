ActiveAdmin.register Device do
  belongs_to :campaign, optional: true, finder: :find_by_slug
  permit_params :name, :serial, :campaign_id, :location_id

  filter :campaign
  filter :location
  filter :name
  filter :serial

  index do
    selectable_column
    id_column
    column :serial
    column :name
    column :campaign
    column :location
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :serial
      f.input :campaign
      f.input :location
    end
    f.actions
  end
end
