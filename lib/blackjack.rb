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

class Deck
  SUITS = ['♦', '♠', '♥', '♣']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

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

  private

  attr_accessor :collection
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

class Game
  attr_accessor :deck, :player_hand, :dealer_hand, :user_input

  def initialize(deck, player_hand, dealer_hand)
    @deck = deck
    @player_hand = player_hand
    @dealer_hand = dealer_hand
  end

  def welcome
    "Welcome to Blackjack!\n\n"
  end

  def initial_deal(whose_hand, their_name)
    whose_hand.add_card(@deck.draw!)
    whose_hand.add_card(@deck.draw!)
    summary = "#{their_name} was dealt #{whose_hand.cards[0].value}#{whose_hand.cards[0].suit}\n"
    summary += "#{their_name} was dealt #{whose_hand.cards[1].value}#{whose_hand.cards[1].suit}\n"
    summary += "#{their_name} Score: #{whose_hand.best_score}\n"
    summary
  end

  def deal(whose_hand, their_name)
    whose_hand.add_card(@deck.draw!)
    summary = "\n#{their_name} was dealt #{whose_hand.cards.last.value}#{whose_hand.cards.last.suit}\n"
    summary
  end

  def hit(whose_hand, their_name)
    summary = "#{deal(whose_hand, their_name)}"
    summary += "#{their_name} Score: #{whose_hand.best_score}"
    summary
  end

  def hit_or_stand
    print "\nHit or stand (H/S): "
  end

  def dealer_turn
    print "\n" + initial_deal(dealer_hand, "Dealer")

    until dealer_hand.best_score >= 17
      puts hit(dealer_hand, "Dealer")
    end

    if dealer_hand.best_score >= 17 && dealer_hand.best_score <= 21
      print "\nDealer stands"
    end
  end

  def continue_turn
    if player_hand.best_score == 21
      puts "\nPlayer Score is 21! End turn!\n"
      puts dealer_turn
    elsif player_hand.best_score > 21
      "\nBust! You lose..."
    elsif player_hand.best_score < 21
      prompt_player
    end
  end

  def user_input
    gets.chomp.downcase
  end

  def prompt_player
    hit_or_stand
    @player_choice = user_input
    if @player_choice == "s"
      puts dealer_turn
    elsif @player_choice == "h"
      hit(player_hand, "Player")
      continue_turn
    else
      puts "Invalid Input, try again.\n"
      continue_turn
    end
  end

  def winner
    if dealer_hand.best_score > 21
      "Bust! You win!"
    elsif dealer_hand.best_score > player_hand.best_score &&
       player_hand.best_score <= 21 &&
       dealer_hand.best_score <= 21
      "Dealer wins!"
    elsif player_hand.best_score > dealer_hand.best_score &&
      player_hand.best_score <= 21 &&
      dealer_hand.best_score <= 21
      "You win!"
    elsif player_hand.best_score == dealer_hand.best_score
      "Tie! No one wins."
    end
  end

end

def new_game
  game = Game.new(Deck.new, Hand.new, Hand.new)
  puts game.welcome
  puts game.initial_deal(game.player_hand, "Player")
  puts game.continue_turn
  puts game.winner
end

new_game
