require 'user_repository'
require 'user'

def reset_users_table
  seed_sql = File.read('spec/seeds_chitter.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do
    reset_users_table
  end
  
  context 'create' do
    it 'creates a new user' do
      repo = UserRepository.new
      new_user = User.new

      new_user.id = '3'
      new_user.name = 'Nick'
      new_user.email = 'nick@gmail.com'
      new_user.username = '@nnn'
      new_user.password = 'nickpss'

      repo.create(new_user)

      all_users = repo.all
      newest_user = users.last

      expect(all_users.length).to eq(3)
      expect(newest_user.id).to eq '3'
      expect(last_user.name).to eq 'Nick'
      expect(last_user.email).to eq 'nick@gmail.com'
      expect(last_user.username).to eq '@nnn'
      expect(last_user.password).to eq 'nickpss'

    end

    context 'find_by_email' do
      it 'finds user from their email' do
        repo = UserRepository.new

        user = repo.find('artur@gmail.com')

        expect(user.id).to eq(1)
        expect(user.name).to eq('Artur')
      end
    end
end