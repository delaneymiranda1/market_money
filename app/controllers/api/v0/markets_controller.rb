class Api::V0::MarketsController < ApplicationController
  def index 
    markets = Market.all
    render json: MarketSerializer.format_markets(markets)
  end

  def show 
    market = Market.find(params[:id])
    render json: MarketSerializer.format_markets(markets)
  end
end