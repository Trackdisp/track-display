ActiveAdmin.register Company do
  permit_params :name, :logo

  controller do
    def update
      redirect_to_company unless nil_or_image?
      super if nil_or_image?
    end

    def create
      redirect_to_company unless nil_or_image?
      super if nil_or_image?
    end

    private

    def nil_or_image?
      logo = permitted_params[:company][:logo]
      logo.nil? || (logo.content_type&.start_with? 'image')
    end

    def redirect_to_company
      redirect_to admin_company_path(permitted_params[:company]),
        alert: t('active_admin.company.errors.not_an_image')
    end
  end

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
        logo = company.logo
        if logo.attached? && logo.variable?
          image_tag logo.variant(resize: '100x100')
        elsif logo.attached?
          image_tag(logo, size: '100x100')
        end
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
