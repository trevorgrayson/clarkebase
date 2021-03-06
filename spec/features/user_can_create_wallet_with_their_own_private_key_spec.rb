require 'rails_helper'

RSpec.feature "User can create a wallet with their own key" do
  scenario "a registered user with no wallet is offered to create a wallet", js: true do
    VCR.use_cassette("wallet/import") do
      user = create(:user)
      login_as user, scope: :user

      visit new_wallet_path

      expect(user.primary_wallet).to eq(nil)

      within(".new-wallet-message") do
        expect(page).to have_content "You Need a Wallet"
        fill_in "private_key", with: ENV["PRIVATE_KEY"]
        find("#createNewWallet").trigger("click")
      end

      wait_for_ajax

      expect(current_path).to eq dashboard_path
      expect(Wallet.find_by(user_id: user.id).user_id).to eq user.id
    end
  end
end
