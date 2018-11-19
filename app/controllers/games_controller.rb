require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = []
    10.times { @grid << ('A'..'Z').to_a.sample }
  end

  def score
    base_letters = params[:letters]
    word = params[:name].upcase
    if english_word?(word) && included?(word, base_letters)
      @answer = "Congratulations! #{word} is a valid English word !"
    elsif !english_word?(word) &&  included?(word, base_letters)
      @answer = "Sorry but #{word} does not seem to be a valid English word ..."
    else
      @answer = "Sorry but #{word} can't be built from #{params[:letters]}"
   end
  end

  def included?(word, base_letters)
    word.chars.all? { |letter| word.count(letter) <= base_letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
