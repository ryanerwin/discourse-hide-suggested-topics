require "rails_helper"

describe("Hide suggested topics") {
  let(:user) { Fabricate(:user) }
  let(:topic) { Fabricate(:topic) }

  before {
    user.custom_fields["hide_suggested_topics"] = true
    user.save!
  }

  describe("plugin enabled") {
    before { SiteSetting.hide_suggested_topics_enabled = true }

    it("should not include suggested_topics if user option is checked") {
      topic_view = TopicView.new(topic.id, user)
      expect(topic_view.suggested_topics).to eq(nil)
    }

    it("should include suggested_topics if user option is unchecked") {
      user.custom_fields["hide_suggested_topics"] = nil
      user.save!
      topic_view = TopicView.new(topic.id, user)
      expect(topic_view.suggested_topics).to_not eq(nil)
    }

  }

  describe("plugin disabled") {
    before { SiteSetting.hide_suggested_topics_enabled = false }

    it("should include suggested_topics") {
      topic_view = TopicView.new(topic.id, user)
      expect(topic_view.suggested_topics).to_not eq(nil)
    }
  }
}