#!/usr/bin/env ruby
require 'pry'

class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def type
    faces = ['J', 'Q', 'K']
    if faces.include? value
      return 'face'
    elsif value == 'A'
      return 'ace'
    else
      return 'numeric'
    end
  end

end

SUITS = ['♦', '♠', '♥', '♣']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

class Deck
  attr_accessor :collection

  def initialize
    @collection = []
    SUITS.each do |suit|
      VALUES.each do |value|
        @collection << Card.new(suit, value)
      end
    end
    @collection.shuffle!
  end

  def deck_total
    @collection.size
  end

  def draw!
    @collection.pop
  end

end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def best_score
    score = 0
    ace_array = []
    @cards.each do |card|
      if card.type == 'face'
        score += 10
      elsif card.type == 'numeric'
        score += card.value.to_i
      elsif card.type == 'ace'
        ace_array << card
      end
    end
      score += ace_calculation(score, ace_array)
      score
  end

  def ace_calculation(score, ace_array)
    if ace_array.size == 0
      return 0
    elsif ace_array.size == 1
      if score + 11 > 21
        return 1
      else
        return 11
      end
    elsif ace_array.size > 1
      return ace_array.size
    end
  end

end

# deck = Deck.new
# hand = Hand.new
# hand.add_card(deck.draw!)

class Game
  attr_accessor :deck, :player_hand, :dealer_hand, :user_input

  def initialize(deck, player_hand, dealer_hand)
    @deck = deck
    @player_hand = player_hand
    @dealer_hand = dealer_hand
  end

  def welcome
    "Welcome to Blackjack!"
  end

  def initial_deal(whose_hand, their_name)
    whose_hand.add_card(@deck.draw!)
    whose_hand.add_card(@deck.draw!)
    summary = "#{their_name} was dealt #{whose_hand.cards[0].value}#{whose_hand.cards[0].suit}\n"
    summary += "#{their_name} was dealt #{whose_hand.cards[1].value}#{whose_hand.cards[1].suit}\n"
    summary += "#{their_name} Score: #{whose_hand.best_score}\n"
    puts summary
  end

  def deal(whose_hand, their_name)
    whose_hand.add_card(@deck.draw!)
    summary = "\n#{their_name} was dealt #{whose_hand.cards.last.value}#{whose_hand.cards.last.suit}\n"
    summary
  end

  def hit(whose_hand, their_name)
    summary = "#{deal(whose_hand, their_name)}"
    summary += "#{their_name} Score: #{whose_hand.best_score}\n"
    puts summary
  end

  def stand
    puts "You stood\n\n"
  end

  def hit_or_stand
    print "Hit or stand (H/S):"
  end

  def dealer_turns
    initial_deal(dealer_hand, "Dealer")
    if dealer_hand.best_score < 17
      hit(dealer_hand, "Dealer")
    elsif dealer_hand.best_score == 21
      puts "Dealer stands"
    elsif dealer_hand.best_score > 21
      puts "Dealer busts"
    end
  end

  def continue_turn
    if player_hand.best_score == 21
      puts "\nPlayer Score is 21! End turn!\n"
      dealer_turns
    elsif player_hand.best_score > 21
      "\nPlayer has busted. :( You lost!"
    elsif player_hand.best_score < 21
      hit_or_stand
      prompt_player
    end
  end

  def prompt_player
    player_choice = gets.chomp.downcase
    if player_choice == "s"
      stand
      dealer_turns
    elsif player_choice == "h"
      hit(player_hand, "Player")
      continue_turn
    else
      puts "Invalid Input, try again.\n"
      continue_turn
    end
  end

  def winner
    if dealer_hand.best_score > 21
      "You win!"
    elsif dealer_hand.best_score > player_hand.best_score
      "Dealer wins!"
    elsif player_hand.best_score > dealer_hand.best_score
      "You win!"
    end
  end

end

def new_game
  game = Game.new(Deck.new, Hand.new, Hand.new)
  game.welcome
  puts game.initial_deal(game.player_hand, "Player")
  puts game.continue_turn
  puts game.winner
end

new_game
