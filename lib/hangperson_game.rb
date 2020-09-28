class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(character)
    if /[^a-zA-Z]/.match(character) || character.nil? || character.empty?
      raise ArgumentError, "#{character} is not a valid character"
    end
    regex = Regexp.new(character, true)
    if regex.match(@word)
      if !regex.match(@guesses)
        @guesses += character
        return true
      else
        return false
      end
    else
      if !regex.match(@wrong_guesses)
        @wrong_guesses += character
        return true
      else
        return false
      end
    end
  end

  def word_with_guesses
    result = ''
    @word.split('').each do |character|
      regex = Regexp.new(character, true)
      result += regex.match(@guesses) ? character : '-'
    end
    result
  end

  def check_win_or_lose
    regex = Regexp.new('-', true)
    if @wrong_guesses.length >= 7
      return :lose
    elsif !regex.match(word_with_guesses)
      return :win
    else
      return :play
    end
  end

end
