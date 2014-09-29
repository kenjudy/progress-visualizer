require 'spec_helper'

describe YesterdaysWeatherChart, :type => :model do
  let(:yesterdays_weather_chart) { FactoryGirl.build(:yesterdays_weather_chart) }
  subject { yesterdays_weather_chart }
  
  context "types_of_work" do
    its(:types_of_work) { is_expected.to eq ['red', nil] }
    context "has dupes" do
      subject { YesterdaysWeatherChart.types_of_work([double('UserProfile', labels_types_of_work: 'red,blue'), double('UserProfile', labels_types_of_work: 'red,orange')]) }
      it { is_expected.to eq ['red','blue','orange', nil]}
    end
    context "has blanks" do
      subject { YesterdaysWeatherChart.types_of_work([double('UserProfile', labels_types_of_work: 'red,blue'), double('UserProfile', labels_types_of_work: '')]) }
      it { is_expected.to eq ['red','blue', nil]}
    end
  end
end