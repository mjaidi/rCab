ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        # span I18n.t("active_admin.dashboard_welcome.welcome")
        # small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "Recent Courses" do
          table_for Course.where(status: 'finished').order("id desc").limit(10) do
            column("Date") { |course| course.created_at.strftime('%d/%m/%Y - %H:%M') }
            column("User") { |course| link_to(course.client.id, admin_user_path(course.client)) }
            column("Driver") { |course| link_to(course.driver.id, admin_user_path(course.driver)) }
            column("Start Address") { |course| course.start_address }
            column("End Address") { |course| course.end_address}
            column("Price")   { |course|  course.price }
            column("Note")   { |course|  course.note }
          end
        end
      end

      column do
        panel "Recent Users" do
          table_for User.where.not(driver: true).order("id desc").limit(10).each do |_user|
            column(:id) { |user| link_to(user.id, admin_user_path(user)) }
            column(:phone){ |user| user.phone}
            column(:first_name)    { |user| user.first_name}
            column(:last_name)   { |user| user.last_name}
          end
        end
        panel "Recent Drivers" do
          table_for User.where(driver: true).order("id desc").limit(10).each do |_user|
            column(:id) { |user| link_to(user.id, admin_user_path(user)) }
            column(:phone){ |user| user.phone}
            column(:first_name)    { |user| user.first_name}
            column(:last_name)   { |user| user.last_name}
          end
        end
      end
    end # columns
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
