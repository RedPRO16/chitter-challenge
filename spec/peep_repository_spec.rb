require 'peep_repository'
require 'peep'

def reset_peeps_table
  seed_sql = File.read('spec/seeds_chitter.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter' })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) do
    reset_peeps_table
  end
end

it 'list all peeps' do
  repo = PeepRepository.new
  peeps = repo.all

  expect(peeps.length).to eq (2)
  expect(peeps.id).to eq 2
  expect(peeps.content).to eq "Today is very hot day!"
  expect(peeps.timestamp).to eq '2022-08-03 13:00:00'
  expect(peeps.username).to eq '@dd'
  expect(peeps.user_id).to eq 1


  expect(peeps.id).to eq 1
  expect(peeps.content).to eq 'Hello world'
  expect(peeps.timestamp).to eq '2022-06-08 09:00:00'
  expect(peeps.username).to eq '@dd'
  expect(peeps.user_id).to eq 2


end

it 'create new peep to list' do
  repo = PeepRepository.new
  peep = Peep.new

  peep.content ='When are you going to holiday?'
  peep.timestamp ='2022-08-03 12:00:00'
  peep.username = '@aa'
  peep.user_id = 2

  repo.create(peep_new)
  peeps = repo.all
  peep_newest = peeps.first

  expect(peep_newest.content).to eq 'When are you going to holiday?'
  expect(peep_newest.timestamp).to eq '2022-08-03 12:00:00'
  expect(peep_newest.username).to eq '@aa'
  expect(peep_newest.user_id).to eq 2
end

