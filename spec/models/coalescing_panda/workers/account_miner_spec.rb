require 'rails_helper'

RSpec.describe CoalescingPanda::Workers::CourseMiner, :type => :model do
  let(:account) { FactoryGirl.create(:account) }
  let(:worker) { CoalescingPanda::Workers::AccountMiner.new(account, [:users]) }
  let(:users_response) {[
    {"id"=>1, "name"=>"teacher@test.com", "sortable_name"=>"teacher@test.com", "short_name"=>"teacher@test.com", "login_id"=>"teacher@test.com"},
    {"id"=>2, "name"=>"student1@test.com", "sortable_name"=>"student1@test.com", "short_name"=>"student1@test.com", "login_id"=>"student1@test.com"},
    {"id"=>3, "name"=>"student2@test.com", "sortable_name"=>"student2@test.com", "short_name"=>"student2@test.com", "login_id"=>"student2@test.com"}
  ]}

  before do
    Bearcat::Client.any_instance.stub(:list_users) { double(Bearcat::ApiArray, :all_pages! => users_response) }
  end

  describe '#initialize' do
    it 'should set instance variables a user' do
      expect(worker.account).to eq account
      expect(worker.options).to eq [:users]
      expect(worker.batch).to eq CoalescingPanda::CanvasBatch.last
    end
  end

  describe '#api_client' do
    it 'returns a bearcat API client' do
      expect(worker.api_client.class).to eq Bearcat::Client
    end
  end

  describe '#start' do
    it 'updates the batch to started' do
      worker.start
      expect(worker.batch.status).to eq 'Completed'
    end
  end

  describe '#create_records' do
    it 'creates users' do
      CoalescingPanda::User.destroy_all
      worker.sync_users(users_response)
      expect(CoalescingPanda::User.count).to eq 3
    end
  end

  describe '#standard_attributes' do
    let(:start_time) { Time.now.iso8601 }
    let(:end_time) { 3.weeks.from_now.iso8601 }

    it 'returns a users attributes' do
      attributes = {"id"=>1, "name"=>"teacher@test.com", "sortable_name"=>"teacher@test.com", "short_name"=>"teacher@test.com", "login_id"=>"teacher@test.com"}
      record = CoalescingPanda::User.new
      expect(worker.standard_attributes(record, attributes)).to eq({"name"=>"teacher@test.com", "login_id"=>"teacher@test.com"})
    end
  end

  describe "#setup_batch" do
    it 'should return a new batch if none are in progress' do
      batch = worker.setup_batch
      expect(batch.status).to eq 'Queued'
    end

    it 'should return a started batch if one exists' do
      batch = worker.setup_batch
      batch.update_attributes(status: 'Started')
      batch = worker.setup_batch
      expect(batch.status).to eq 'Started'
    end
  end
end
