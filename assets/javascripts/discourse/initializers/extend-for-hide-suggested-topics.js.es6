import computed from 'ember-addons/ember-computed-decorators';
import PreferencesInterface from "discourse/controllers/preferences/interface";
import suggestedTopics from "discourse/components/suggested-topics";

export default {
  name: "extend-for-hide-suggested-topics",
  initialize() {

    suggestedTopics.reopen({

      classNameBindings: ['hideSuggestedTopics:hidden'],

      @computed("siteSettings.hide_suggested_topics_enabled", "currentUser.custom_fields.hide_suggested_topics")
      hideSuggestedTopics(isEnabled, userEnabled) {
        return isEnabled && userEnabled;
      }

    });

    PreferencesInterface.reopen({

      saveAttrNames: function() {
        const attrs = this._super(...arguments);
        if (!attrs.includes("custom_fields")) attrs.push("custom_fields");
        return attrs;
      }.property(),

      _updateHideSuggestedTopics: function() {
        const saved = this.get("saved");
        const currentUser = this.get("currentUser");

        if (saved && currentUser && this.get("model.id") == currentUser.get("id")) {
          currentUser.set("hide_suggested_topics", this.get("model.custom_fields.hide_suggested_topics"));
        }
      }.observes("saved")

    });

  }
};