FactoryGirl.define do
  factory :account, class: LtiAccount do
    sequence :name do |n|
      "Account #{n}"
    end

    sequence :key do |n|
      "Key #{n}"
    end

    sequence :secret do |n|
      "Account #{n}"
    end

    oauth2_client_id "1234"
    oauth2_client_key "thisisadeveloperkey"
    settings { {base_url: "http://localhost:3000", account_admin_api_token: "9q2083uy4poiahjfgpoawy"} }
  end
end