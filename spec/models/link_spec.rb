# frozen_string_literal: true

RSpec.describe Link, type: :model do
  let!(:link) { create(:link) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :url }
    it { is_expected.to validate_presence_of :short_url }
    it { is_expected.to validate_length_of(:url).with_maximum Settings.validation.string.length.max }
    it { is_expected.to validate_length_of(:short_url).with_maximum Settings.validation.string.length.max }
    it { is_expected.to validate_uniqueness_of :url }
    it { is_expected.to validate_uniqueness_of :short_url }
  end

  describe '.url_exists?' do
    context 'when value not exists' do
      it 'should return false' do
        expect(Link.url_exists?('a')).to be_falsey
      end
    end

    context 'when value exists' do
      it 'should return true' do
        expect(Link.url_exists?(link.url)).to be_truthy
      end
    end
  end

  describe '.shorten_url_exists?' do
    context 'when value not exists' do
      it 'should return false' do
        expect(Link.shorten_url_exists?('a')).to be_falsey
      end
    end

    context 'when value exists' do
      it 'should return true' do
        expect(Link.shorten_url_exists?(link.short_url)).to be_truthy
      end
    end
  end

  describe '.encode' do
    context 'when value not exists' do
      it 'should return null' do
        expect(Link.encode('a')).to be_nil
      end
    end

    context 'when value exists' do
      it 'should return short url' do
        expect(Link.encode(link.url)).to eq(link.full_short_url)
      end
    end
  end

  describe '.decode' do
    context 'when value not exists' do
      it 'should return null' do
        expect(Link.decode('a')).to be_nil
      end
    end

    context 'when value invalid' do
      it 'should return short url' do
        expect(Link.decode(link.short_url)).to be_nil
      end
    end

    context 'when value valid' do
      it 'should return short url' do
        expect(Link.decode(link.full_short_url)).to eq(link.url)
      end
    end
  end
end
