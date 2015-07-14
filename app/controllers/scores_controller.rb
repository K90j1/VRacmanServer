class ScoresController < ApplicationController
	protect_from_forgery :except => :create

	def index
		@scores = Score.all
	end

	def show
		score_num = Score.maximum('score')
		if score_num.nil?
			score_num = '%05d' % 0
		end
		score = {
				'score' => '%05d' % score_num,
		}
		render json: score
  end

  def create
    @score = Score.new(score_params)
		if @score.save
			score_num = '%05d' % score_params[:score]
			status = "@#{score_params[:name]} のスコア #{score_num}"
			if Score.maximum('score') < score_params[:score].to_i
				status = " ☆最高得点☆ @#{score_params[:name]} のスコア #{score_num}！！"
			end
			client = Twitter::REST::Client.new do |config|
				config.consumer_key        = 'nC9zyaLl0ofz3a3gPLSvRlvgT'
				config.consumer_secret     = 'rgxlT8xNcpWsxG4b5bI4VBfR5e7yTjnR8yY5pqN00U17ZHdvy7'
				config.access_token        = '3279813967-7C8CbY97bbJKU81g2UPpK1pAqrOkUAMC8q0YNNq'
				config.access_token_secret = 'oX2T2R5lRc04wSbSUuaVqcPBaPZ9MrQGwt8i1ZjgSKc8Y'
			end
			client.update(status.to_str)
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
