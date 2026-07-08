# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

def load_memos
  unless File.exist?('data/memos.json')
    File.write('data/memos.json', '{}')
    return {}
  end

  file = File.read('data/memos.json')
  file.empty? ? {} : JSON.parse(file)
end

def save_memos(memos_list)
  json_memos_list = memos_list.to_json
  File.write('data/memos.json', json_memos_list)
end

def build_memo(params)
  {
    title: params[:title],
    content: params[:content]
  }
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos_list = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do |id|
  memos_list = load_memos

  halt 404 if !memos_list.key?(id)

  @memo = { memo_id: id, title: memos_list[id]['title'], content: memos_list[id]['content'] }

  erb :show
end

get '/memos/:memo_id/edit' do |id|
  memos_list = load_memos

  halt 404 if !memos_list.key?(id)

  @memo = { memo_id: id, title: memos_list[id]['title'], content: memos_list[id]['content'] }

  erb :edit
end

post '/memos' do
  memos_list = load_memos

  memo_id = SecureRandom.uuid

  memos_list[memo_id] = build_memo(params)

  save_memos(memos_list)

  redirect "/memos/#{memo_id}"
end

patch '/memos/:memo_id' do
  memos_list = load_memos

  memo_id = params[:memo_id]

  memos_list[memo_id] = build_memo(params)

  save_memos(memos_list)

  redirect "/memos/#{memo_id}"
end

delete '/memos/:memo_id' do
  memos_list = load_memos

  memo_id = params[:memo_id]
  memos_list.delete(memo_id.to_s)

  save_memos(memos_list)

  redirect '/memos'
end

not_found do
  status 404
  erb :notfound, layout: false
end
