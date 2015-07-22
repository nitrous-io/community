require 'rails_helper'

shared_examples 'publishable' do
  describe 'publish_with!' do
    it 'marks as published' do
      Timecop.freeze do
        subject.publish_with({ title: 'new title' })
        expect(subject.title).to eq('new title')
        expect(subject.state).to eq('published')
        expect(subject.published_at.to_i).to eq(Time.now.to_i)
      end
    end

    it 'sets published_at to specified time' do
      Timecop.freeze do
        subject.publish_with({ title: 'new title' }, 1.day.from_now)
        expect(subject.title).to eq('new title')
        expect(subject.state).to eq('published')
        expect(subject.published_at.to_i).to eq(1.day.from_now.to_i)
      end
    end
  end

  describe 'unpublish!' do
    it 'marks as unpublished' do
      subject.unpublish
      expect(subject.state).to eq('draft')
      expect(subject.published_at).to be_nil
    end
  end

  describe 'drafted' do
    it 'returns unpublished posts or posts that are not published yet' do
      subject.update_attributes(state: :published, published_at: 1.day.ago)
      expect(described_class.drafted).not_to include(subject)

      subject.update_attributes(published_at: 1.day.ago, state: :draft)
      expect(described_class.drafted).to include(subject)

      subject.update_attributes(published_at: 1.day.ago, state: :deleted)
      expect(described_class.drafted).not_to include(subject)

      subject.update_attributes(published_at: 1.day.from_now, state: :published)
      expect(described_class.drafted).to include(subject)
    end
  end
end