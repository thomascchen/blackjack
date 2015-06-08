require_relative '../../lib/blackjack'
require 'pry'

describe Card do
  let(:card) { Card.new('♥', '8') }

  it 'should have a suit' do
    expect(card.suit).to eq('♥')
  end

  it 'should have a value' do
    expect(card.value).to eq('8')
  end

  describe '#type' do
    it 'should tell us that the card is a numeric card' do
      expect(card.type).to eq('numeric')
    end

    it 'should tell us that the card is an ace' do
      card = Card.new('♥', 'A')
      expect(card.type).to eq('ace')
    end

    it 'should tell us that the card is a face card' do
      card = Card.new('♥', 'Q')
      expect(card.type).to eq('face')
    end

  end

end # end Card class test block

describe Deck do
  let(:deck) { Deck.new }

  describe '#deck_total' do
    it 'should have 52 cards' do
      expect(deck.deck_total).to eq(52)
    end
  end

  describe '#draw' do
    it 'should subtract one card from the deck total' do
      expect(deck.draw!).to be_a(Card)
      expect(deck.deck_total).to eq(51)
    end
  end

end # end Deck class test block

describe Hand do
  let(:deck) { Deck.new }
  let(:hand) { Hand.new }

  describe '#add_card' do
    it 'should have one card object' do
      expect(hand.add_card(deck.draw!).size).to eq(1)
    end
  end

  describe '#best_score' do
    it 'should return the best possible score' do
      expect(hand.best_score).to be_a(Integer)
    end
  end

    context 'where hand is an ace and a face card' do
      it 'should return 21' do
        hand.add_card(Card.new('♥', 'A'))
        hand.add_card(Card.new('♥', 'J'))
        expect(hand.best_score).to eq(21)
      end
    end

    context 'where hand is an ace and a numeric' do
      it 'should return 13' do
        hand.add_card(Card.new('♥', 'A'))
        hand.add_card(Card.new('♥', '2'))
        expect(hand.best_score).to eq(13)
      end
    end

    context 'where a three-card hand is dealt: ace, face, numeric' do
      it 'should return 13' do
        hand.add_card(Card.new('♥', 'A'))
        hand.add_card(Card.new('♥', '2'))
        hand.add_card(Card.new('♥', 'J'))
        expect(hand.best_score).to eq(13)
      end
    end

    context 'where a hand has two aces and a face card' do
      it 'should return 12' do
        hand.add_card(Card.new('♥', 'A'))
        hand.add_card(Card.new('♥', 'A'))
        hand.add_card(Card.new('♥', 'Q'))
        expect(hand.best_score).to eq(12)
      end
    end

  end # end Hand class test block

  describe Game do
    let(:game) { Game.new(Deck.new, Hand.new, Hand.new) }

    context 'a new game begins' do
      it 'should have a deck' do
        expect(game.deck).to be_a(Deck)
      end

      it 'should have a player hand' do
        expect(game.player_hand).to be_a(Hand)
      end

      it 'should have a dealer hand' do
        expect(game.dealer_hand).to be_a(Hand)
      end

      it 'should welcome you when you start a game' do
        expect(game.welcome).to eq("Welcome to Blackjack!")
      end

      it 'should deal two cards to the player with their suits and values' do
        game.deal(game.player_hand, "Player")
        game.deal(game.player_hand, "Player")
        expect(game.player_hand.cards.size).to eq(2)
        expect(game.deal(game.player_hand, "Player")).to include("Player was dealt")
      end

      it 'should deal two cards to the dealer with their suits and values' do
        game.deal(game.dealer_hand, "Dealer")
        game.deal(game.dealer_hand, "Dealer")
        expect(game.dealer_hand.cards.size).to eq(2)
        expect(game.deal(game.dealer_hand, "Dealer")).to include("Dealer was dealt")
      end

      it 'should deal another card if the player hits' do
        game.deal(game.player_hand, "Player")
        game.deal(game.player_hand, "Player")
        player_choice = "h"
        game.prompt_player(player_choice)
        expect(game.player_hand.cards.size).to eq(3)
      end

      it 'should ask for input again if input is invalid' do
        player_choice = "x"
        expect(game.prompt_player(player_choice)).to eq("Input is invalid, try again")
      end

    end


  end # end Game
