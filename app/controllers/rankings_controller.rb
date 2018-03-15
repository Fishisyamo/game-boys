class RankingsController < ApplicationController
  def favo
    @rank_name = "Favo"
    @ranking_counts = Favo.ranking
    @items = Item.find(@ranking_counts.keys)
    render 'ranking'
  end

  def play
    @rank_name = "Play"
    @ranking_counts = Play.ranking
    @items = Item.find(@ranking_counts.keys)
    render 'ranking'
  end
end