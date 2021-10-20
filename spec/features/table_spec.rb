describe "the home page", type: "feature" do
  it "has the logo" do
    visit '/'
    expect(page).to have_content "CryptoData"
  end
end