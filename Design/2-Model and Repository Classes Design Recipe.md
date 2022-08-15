# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: users

Columns:
id | email | password | name | username

Table : peeps

Columns:
id | content | timestamp | username
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_chitter.sql)
--

-- Write your SQL seed here.

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO users (email, password, name, username) VALUES
('David@gmail.com', 'dvd123', 'David', 'dd'),
('Anna@gmail.com', 'ann321', 'Anna', 'aa'  );


TRUNCATE TABLE peeps RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO peeps (content, timestamp, username, user_id) VALUES
('Hello world', '2022-06-08 09:00:00', '@dd', 1),
('Today is very hot day!', '2022-08-03 12:00:00', '@dd' 1),
('When are you going to holiday?', '2022-07-17 17:00:00', '@aa' 2);

```
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 chitter < seeds_chitter.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end


class Peep
end

class PeepRepository
end

```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users
# Table name: peeps

# Model class
# (in lib/user.rb)
# (in lib/peep.rb)

class User

  # Replace the attributes by your own columns.
  attr_accessor :id, :email, :password, :name, :username
end

class Peer

  # Replace the attributes by your own columns.
  attr_accessor :id, :content, :timestamp, :username, :user_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: users

# Repository class
# (in lib/user_repository.rb)

# Table name: peeps

# Repository class
# (in lib/peep_repository.rb)
class UserRepository

  def create(user)
    # Executes the SQL query:
    # INSERT INTO users (name, email, username, password) VALUES ($1, $2, $3, $4);'
  end
end

class PeepRepository
  def all
    # Executes the SQL query:
    # SELECT * FROM peeps;
  end

  #post a peep
  def create(peep)
    # Executes the SQL query:
    # INSERT INTO users (content, timestamp, username, user_id) VALUES ($1, $2, $3, $4);'
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES
#1- Create a user

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

#2 Get all peeps

 repository = PeepRepository.new

  peeps = repository.all

  peeps.length # => 3

  peeps[0].id # => 1
  peeps[0].content # => 'Hello world'
  peeps[0].timestamp # => '2022-06-08 09:00:00'
  peeps[0].username # => '@dd'
  peeps[0].user_id # => 1

  peeps[1].id # => 2
  peeps[1].content # => "Today is very hot day!"
  peeps[1].timestamp # => '2022-08-03 12:00:00'
  peeps[1].username # => '@dd'
  peeps[1].user_id # => 1

#3 Create a peep to list
repo = PeepRepository.new
peep = Peep.new

peep.content # => 'When are you going to holiday?'
peep.timestamp # => '2022-08-03 12:00:00'
peep.username #=> @aa
peep.user_id #=> 2

repository.create(peep_new)
peeps = repo.all
peep_newest = peeps.first

expect(peep_newest.content).to eq 'When are you going to holiday?'
expect(peep_newest.timestamp).to eq '2022-08-03 12:00:00'
expect(peep_newest.username).to eq '@aa'
expect(peep_newest.user_id).to eq 2


```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds_chitter.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do
    reset_users_table
  end

  # (your tests will go here).
end


# file: spec/peep_repository_spec.rb

def reset_peeps_table
  seed_sql = File.read('spec/seeds_chitter.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter' })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) do
    reset_peeps_table
  end

```
## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->
