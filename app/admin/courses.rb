ActiveAdmin.register Course do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  index do
    selectable_column
    column :id
    column :created_at
    column :client_id
    column :driver_id
    column :start_address
    column :end_address
    column :price
    column :distance
    column :duration
    column :note
    column :comment
    actions
  end
   permit_params :start_address, :end_address, :price, :client_id, :driver_id, :note, :comment, :status, :start_lat, :start_lon, :end_lat, :end_lon, :distance, :duration
  #
  # or
  #
  # permit_params do
  #   permitted = [:start_address, :end_address, :price, :client_id, :driver_id, :note, :comment, :status, :start_lat, :start_lon, :end_lat, :end_lon, :distance, :duration]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
