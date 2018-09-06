ActiveAdmin.register Measure do
  permit_params :device_id, :measured_at, :avg_age, :w_id, :presence_duration, :contact_duration,
    :happiness, :gender

  controller do
    def upload_csv
      if params[:csv].nil?
        fail_upload(t("active_admin.measures.upload.empty"))
      elsif !params[:csv].original_filename.end_with? ".csv"
        fail_upload(t("active_admin.measures.upload.extension_error"))
      else
        save_measures(CSV.parse(params[:csv].read))
        redirect_to admin_measures_path, notice: t("active_admin.measures.upload.success")
      end
    rescue ActiveRecord::RecordInvalid
      fail_upload(t("active_admin.measures.upload.format_error"))
    rescue
      fail_upload(t("active_admin.measures.upload.general_error"))
    end

    private

    def fail_upload(alert)
      redirect_to admin_measures_path, alert: alert
    end

    def save_measures(csv_data)
      csv_data[1..-1].each do |row|
        Measure.create!(
          device_id: row[0],
          measured_at: row[1],
          avg_age: row[2],
          w_id: row[3],
          presence_duration: row[4],
          contact_duration: row[5],
          happiness: row[6],
          gender: row[7]
        )
      end
    end
  end

  collection_action :upload, method: :get do
    @page_title = t("active_admin.measures.upload.title")
  end

  action_item :upload, only: :index do
    link_to t("active_admin.measures.upload.button"), upload_admin_measures_path
  end

  filter :device
  filter :campaign
  filter :campaign_company_id, as: :select, collection: -> { Company.all }
  filter :location
  filter :measured_at

  index do
    selectable_column
    id_column
    column :campaign
    column :measured_at
    column :location
    column :device
    column :avg_age
    column :contact_duration
    column :gender
    column :happiness
    actions
  end

  show do
    attributes_table do
      row :campaign
      row :measured_at
      row :location
      row :device
      row :avg_age
      row :contact_duration
      row :gender
      row :happiness
      row :w_id
      row :presence_duration
    end
  end

  form do |f|
    f.inputs do
      f.input :device
      f.input :measured_at, as: :date_time_picker
      f.input :avg_age
      f.input :contact_duration
      f.input :gender
      f.input :happiness
      f.input :w_id
      f.input :presence_duration
    end
    f.actions
  end
end
