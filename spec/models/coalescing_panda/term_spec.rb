require 'rails_helper'

RSpec.describe CoalescingPanda::Term, :type => :model do
  let(:term) { FactoryGirl.create(:term) }

  context "associations" do
    it 'should belong_to a account' do
      expect(CoalescingPanda::Term.reflect_on_association(:account)).to_not be_nil
      expect(CoalescingPanda::Term.reflect_on_association(:account).macro).to eql(:belongs_to)
    end

    it 'should belong_to a user' do
      expect(CoalescingPanda::Term.reflect_on_association(:courses)).to_not be_nil
      expect(CoalescingPanda::Term.reflect_on_association(:courses).macro).to eql(:has_many)
    end
  end
end