require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = generate_grid(10)
  end

  def score
    @word = params[:word]
    @grid = params[:grid]

    @message = ''

    if !word_in_grid?(@word, @grid)
      @message = "Sorry but #{@word} can't be built out of #{@grid}"
    elsif word_in_grid?(@word, @grid) && !word_in_dictionary?(@word)
      @message = "Sorry but #{@word} is not in the dictionary"
    else
      @message = "Congrats! #{@word} is a valid English word!"
    end
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    # ("A".."Z").to_a.sample(grid_size)
    random_letters = []
    grid_size.times do
      random_letters << ('A'..'Z').to_a.sample
    end
    random_letters
  end

  def word_in_dictionary?(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/' << attempt.to_s
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end

  def word_in_grid?(attempt, grid)
    letters = attempt.upcase.chars
    grid_array = grid

    letters.each do |letter|
      if grid_array.include?(letter)
        grid_array.delete(letter)
      else
        return false
      end
    end
    true
  end
end
