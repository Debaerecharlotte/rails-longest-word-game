require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @alphabet = ('A'..'Z').to_a
    @letters = []
    number = rand(5..10)
    number.times do
      @letters << @alphabet.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @check =  if grid_used?(@word, @letters) && english_word?(@word)
                'Well done!'
              elsif grid_used?(@word, @letters)
                "Sorry, '#{@word}' is not an english word."
              else
                "Sorry, '#{@word}' is not using the letters presented in the grid."
              end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    uri = URI.open(url).read
    uri_json = JSON.parse(uri)
    uri_json['found']
  end

  def grid_used?(word, letters)
    word.upcase.chars.all? do |letter|
      word.upcase.count(letter) <= letters.count(letter)
    end
  end
end
