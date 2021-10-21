describe "the home page", type: "feature" do
  it "has the logo" do
    WebMock.allow_net_connect!

    visit '/'
    expect(page).to have_content "CryptoData"
  end
end