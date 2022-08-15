require_relative 'user'

class UserRepository

  def reset_users_table
    seed_sql = File.read('spec/seeds_chitter.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter' })
    connection.exec(seed_sql)
  end

  describe UserRepository do
    before(:each) do
      reset_users_table
    end


    def create(user)
      sql = 'INSERT INTO users (id, name, username, email, password) VALUES ($1, $2, $3, $4, $5);'
      params = [user.id, user.name, user.username, user.email, user.password]

      DatabaseConnection.exec_params(sql, params)
    end

    def find_by_email(email)

    end

    def log_in(email, password)

    end





  it 'create new user' do
    repo = UserRepository.new
    user = User.new
    user.name = 'Nick'
    user.email = 'nick@gmail.com'
    user.username = '@nnn'
    user.password = 'nickpss'

    repo.create(user)

    users =repo.all
    last_user = users.last

    expect(last_user.name).to eq 'Nick'
    expect(last_user.email).to eq 'nick@gmail.com'
    expect(last_user.username).to eq '@nnn'
    expect(last_user.password).to eq 'nickpss'
  end

end