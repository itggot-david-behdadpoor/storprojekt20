require 'sinatra'
require 'slim'
require 'sqlite3'
require 'BCrypt'

enable :sessions



before do
  session["password"] = "abc123"
  session["user"] = "John Smith"
end

#Startsida
get('/') do
  slim(:index)
end

#Visa formulär som lägger till en note
get('/notes/new') do
  db = SQLite3::Database.new("db/notes.db")
  db.results_as_hash = true
  result = db.execute("SELECT note FROM notes")
  p result
  slim(:"notes/new")
end


#Skapa note
post('/notes/create') do
  db = SQLite3::Database.new("db/notes.db")
  db.results_as_hash = true 
  ny_note = params[:ny_note]

  result = db.execute("INSERT INTO notes (NOTE) VALUES (?)", ny_note)

  slim(:"notes/notes",locals:{notes:result})
end

#Visa alla notes
get('/notes') do
  
  db = SQLite3::Database.new("db/notes.db")
  db.results_as_hash = true 
  result = db.execute("SELECT * FROM  notes")
  slim(:"notes/show",locals:{result:result})
  
end

get('/notes/delete') do
  
  db = SQLite3::Database.new("db/notes.db")
  db.results_as_hash = true 
  result = db.execute("SELECT * FROM  notes")
  slim(:"notes/delete")
  
end


post('/notes/delete') do
  ny_note = params[:ny_note]
  db = SQLite3::Database.new("db/notes.db")
  db.results_as_hash = true 
  db.execute("DELETE FROM notes WHERE note=?",ny_note)
  redirect("/notes")
end