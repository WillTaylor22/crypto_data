describe "the home page", type: "feature" do

  #
  # Simple smoke test for home page.
  # Further feature tests could be here if needed.
  #
  it "has the logo" do
    WebMock.allow_net_connect!
    visit '/'
    expect(page).to have_content "CryptoData"
  end
end