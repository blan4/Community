require 'spec_helper'

describe Event do
  before { @event = FactoryGirl.create :event }

  subject { @event }

  it { should have_field(:name).of_type(String)}
  it { should have_field(:date).of_type(DateTime)}
  it { should have_field(:place).of_type(String)}

  it { should respond_to(:users) }
  it { should have_many(:participations).with_foreign_key(:event_id)}

  it { should validate_presence_of :name }
  it { should validate_presence_of :date }
  
  it { should validate_uniqueness_of(:name).case_insensitive }
  
  it { should be_valid }

end