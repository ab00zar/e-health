# rspec app_spec.rb

require 'rspec'

require_relative '../app.rb'

RSpec.describe "Prices calculator", type: :model do
  let(:data)          { JSON.parse(File.read('data.json')) }
  let(:output)        { JSON.parse(File.read('output.json')) }

  pending("calculates prices")
end

describe Communication do
  subject { described_class.new(
    "id" => 1,
    "practitioner_id" => 1,
    "pages_number" => 1,
    "color" => false,
    "sent_at" => "2019-03-01 18:00:00"
  ) }

  describe '#base_price method' do
    it 'has a base price equals 0.10' do
      expect(subject.base_price).to eq(0.10)
    end
  end

  describe '#color_mode_price method' do

    context 'when color is false' do
      it 'should return 0' do
        expect(subject.color_mode_price).to eq(0)
      end
    end

    context 'when color is true' do
      let(:colored) { described_class.new("color" => true, "sent_at" => "2019-03-01 18:00:00") }
      it 'should return 0.18' do
        expect(colored.color_mode_price).to eq(0.18)
      end
    end

  end

  describe '#additional page price method' do

    context 'when pages number is one' do
      it 'should return 0' do
        expect(subject.additional_page_price).to eq(0)
      end
    end

    let(:two_pages) { described_class.new("pages_number" => 2, "sent_at" => "2019-03-01 18:00:00") }
    context 'when pages number is > one, 2 for example' do
      it 'should return 0.07' do
        expect(two_pages.additional_page_price).to eq(0.07)
      end
    end

  end

end

describe Practitioner do
  subject { described_class.new(
    "id" => 1, 
    "first_name" => "David", 
    "last_name" => "Beckham", 
    "express_delivery" => false)}
  it 'sets each value to its corresponding class attribute' do
    expect(subject.id).to eq(1)
    expect(subject.express_delivery).to be_falsy
  end
end