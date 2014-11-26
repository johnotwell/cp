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

  context "validations" do
    it "should require an account" do
      expect(FactoryGirl.build(:term, coalescing_panda_lti_account_id: "")).to_not be_valid
    end

    it 'should be unique to an account' do
      account = FactoryGirl.create(:account)
      term = FactoryGirl.create(:term, account: account, canvas_term_id: "1")
      expect { FactoryGirl.create(:term, account: account, canvas_term_id: "1") }.to raise_error ActiveRecord::RecordNotUnique
    end
  end
end