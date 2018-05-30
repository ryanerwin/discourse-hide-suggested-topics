# name: hide-suggested-topics
# version: 0.1
# author: Muhlis Budi Cahyono (muhlisbc@gmail.com)
# url: https://github.com/ryanerwin/discourse-hide-suggested-topics

enabled_site_setting :hide_suggested_topics_enabled

after_initialize {

  DiscoursePluginRegistry.serialized_current_user_fields << "hide_suggested_topics"

  User.register_custom_field_type("hide_suggested_topics", :boolean)

  add_to_serializer(:current_user, :hide_suggested_topics) { object.custom_fields["hide_suggested_topics"] }

  class ::TopicView
    alias_method :orig_suggested_topics, :suggested_topics

    def suggested_topics
      SiteSetting.hide_suggested_topics_enabled && @user.present? && @user.custom_fields["hide_suggested_topics"].present? ? nil : orig_suggested_topics
    end
  end

}
