# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

configure do
  set :connection, PG.connect(user: ENV['DB_USER'], dbname: ENV['DB_NAME'])
end

def read_memos
  settings.connection.exec('SELECT * FROM memos ORDER BY created_at DESC')
end

def find_memo(memo_id)
  settings.connection.exec_params('SELECT * FROM memos WHERE id = $1 LIMIT 1', [memo_id]).first
end

def create_memo(params)
  result = settings.connection.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING id', [params[:title], params[:content]])
  result.first['id']
end

def update_memo(memo_id, params)
  settings.connection.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [params[:title], params[:content], memo_id])
end

def delete_memo(memo_id)
  settings.connection.exec_params('DELETE FROM memos WHERE id = $1', [memo_id])
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos_list = read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do |memo_id|
  @memo = find_memo(memo_id)

  halt 404 unless @memo

  erb :show
end

get '/memos/:memo_id/edit' do |memo_id|
  @memo = find_memo(memo_id)

  halt 404 unless @memo

  erb :edit
end

post '/memos' do
  memo_id = create_memo(params)

  redirect "/memos/#{memo_id}"
end

patch '/memos/:memo_id' do
  memo_id = params[:memo_id]

  update_memo(memo_id, params)

  redirect "/memos/#{memo_id}"
end

delete '/memos/:memo_id' do
  memo_id = params[:memo_id]

  delete_memo(memo_id)

  redirect '/memos'
end

not_found do
  status 404
  erb :notfound, layout: false
end
