require 'rubygems'
require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'imdb'


get '/' do
  @movies = []
  movies = File.new('movies.csv', 'r')
  movies.each do |title|
    @movies << title.split(',')
  end
  movies.close
  erb :movies
end



get '/movie/:title' do
  @title = params[:title]
  movies_file = File.new('movies.csv', 'r')
  movies_file.each do |title|
    title.split(',')
    # Identifying the name of the movie
    if title.split(',')[0] == @title
      then @single_movie = title.split(',')
    end
  end
  erb :movie
end

get '/new_movie' do
  erb :new_movie
end

post '/new_movie' do
  @title = params[:title]
  @movie = Imdb::Search.new(@title).movies.first
  movies = File.open('movies.csv', 'a+') do |title|
   title.puts("#{@movie.title},#{@movie.year},#{@movie.director[0]},#{@movie.poster},#{@movie.tagline}")
  end

redirect to ("/movie/#{URI::encode(@movie.title)}")
end