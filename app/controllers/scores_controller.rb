class ScoresController < ApplicationController
	protect_from_forgery :except => :create

	def index
		@scores = Score.all
	end

	def show
		score_num = Score.maximum('score')
		if score_num.nil?
			score_num = '%04d' % 0
		end
		score = {
				'score' => '%04d' % score_num,
		}
		render json: score
  end

  def create
    @score = Score.new(score_params)
		if @score.save
			client = Twitter::REST::Client.new do |config|
				config.consumer_key        = "YOUR_CONSUMER_KEY"
				config.consumer_secret     = "YOUR_CONSUMER_SECRET"
				config.access_token        = "YOUR_ACCESS_TOKEN"
				config.access_token_secret = "YOUR_ACCESS_SECRET"
			end
			client.update("I'm tweeting with @gem!")
		else
			score_params = false
		end
		render json: score_params
	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:name, :score)
    end
end
