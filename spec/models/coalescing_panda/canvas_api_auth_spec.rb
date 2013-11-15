require 'spec_helper'

describe CoalescingPanda::CanvasApiAuth do

  it { should validate_uniqueness_of(:user_id).scoped_to(:api_domain)}
  it { should validate_presence_of(:user_id)}
  it {should validate_presence_of(:api_domain)}


end

