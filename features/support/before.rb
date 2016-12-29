Before '@chrome' do
  Capybara.javascript_driver = :chrome
end

Before '@poltergeist' do
  Capybara.javascript_driver = :poltergeist
end

Before '@stub_et_success' do
  client = double
  allow(ElasticTranscoder).to receive(:client).and_return(client)
  allow(client).to receive(:create_job).and_return(
    job: {
      id: 1
    }
  )
  allow(client).to receive(:read_job).with(id: '1').and_return(
    job: {
      output: {
        status: 'complete',
        status_detail: ''
      }
    }
  )
end
