ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
    index do
      selectable_column
      column :id
      column :phone
      column :first_name
      column :last_name
      column :created_at
      column :admin
      column :driver
      column :verified
      actions
    end

      form  do |f|
        f.inputs do
          f.input :first_name
          f.input :last_name
          f.input :phone
          f.input :password
          # f.input :admin
          f.input :driver
          f.input :verified
          f.input :photo
          f.input :photo_moto
          f.input :photo_cin
        end
        actions
      end


  permit_params :email, :first_name, :last_name, :phone, :admin, :driver, :photo_moto, :photo_cin, :photo, :password, :verified
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :phone, :verified_whatsapp, :admin, :driver, :photo_moto, :photo_cin, :photo, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
