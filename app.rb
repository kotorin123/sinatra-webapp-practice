# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  file = File.read('./data/memos.json')
  @memos_list = file.empty? ? {} : JSON.parse(file)
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do |id|
  file = File.read('./data/memos.json')
  @memos_list = JSON.parse(file)
  @memo_id = id
  halt 404 if !@memos_list.key?(@memo_id)
  erb :show
end

get '/memos/:memo_id/edit' do |id|
  file = File.read('./data/memos.json')
  @memos_list = JSON.parse(file)
  @memo_id = id
  halt 404 if !@memos_list.key?(@memo_id)
  erb :edit
end

post '/memos' do
  file = File.read('./data/memos.json')

  @memos_list = file.empty? ? {} : JSON.parse(file)

  title = params[:title]
  content = params[:content]

  @memo_id = @memos_list.keys.max.to_i + 1

  @memos_list[@memo_id] = { 'title' => title, 'content' => content }
  json_memos_list = @memos_list.to_json

  File.write('data/memos.json', json_memos_list)

  redirect "/memos/#{@memo_id}"
end

patch '/memos/:memo_id' do
  file = File.read('./data/memos.json')

  @memos_list = JSON.parse(file)

  @memo_id = params[:memo_id]
  title = params[:title]
  content = params[:content]

  @memos_list[@memo_id] = { 'title' => title, 'content' => content }
  json_memos_list = @memos_list.to_json

  File.write('data/memos.json', json_memos_list)

  redirect "/memos/#{@memo_id}"
end

delete '/memos/:memo_id' do
  file = File.read('./data/memos.json')
  @memos_list = JSON.parse(file)

  @memo_id = params[:memo_id]
  @memos_list.delete(@memo_id.to_s)
  json_memos_list = @memos_list.to_json

  File.write('data/memos.json', json_memos_list)

  redirect '/memos'
end

not_found do
  status 404
  erb :notfound, layout: false
end
