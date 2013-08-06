require 'spec_helper'

describe Event do
  before { @event = FactoryGirl.create :event }

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:users) }
  it { should respond_to(:newcomers) }
  it { should respond_to(:categories) }

##### ONLY FOR MONGOID ##########
  it { should have_field(:name).of_type(String)}
  it { should have_field(:date).of_type(DateTime)}
  it { should have_field(:place).of_type(String)}
  it { should have_many(:registrations).with_foreign_key(:event_id)}
  it { should validate_presence_of :name }
  it { should validate_presence_of :date }
  it { should validate_uniqueness_of(:name).case_insensitive }
#################################  
  
  it { should be_valid }
  
  describe "when come newcomers they NEW" do
    let(:first_event) { FactoryGirl.create :event }
    let(:user) { FactoryGirl.create :user }

    before { user.registrate_to!(first_event) }

    subject { first_event }
    its(:newcomers) { should be_include(user) }

    describe "when come oldcomers they OLD" do
      let(:second_event) { FactoryGirl.create :event }

      before { user.registrate_to!(second_event) }
  
      subject { second_event }
      its(:newcomers) { should_not be_include(user) }
    end
  end
end
