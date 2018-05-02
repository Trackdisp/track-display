ActiveAdmin.register User do
  permit_params :email, :company_id, :password, :password_confirmation

  filter :email
  filter :company
  filter :created_at

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :company
    column :last_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :company
      row :last_sign_in_at
      row :sign_in_count
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :company
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
