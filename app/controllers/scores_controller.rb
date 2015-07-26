class ScoresController < ApplicationController
	TAG = '-- VRゲーム VRacMan メイカーフェアトーキョー2015で展示中！！'
	protect_from_forgery :except => :create

	def show
		_score_num = Score.maximum('score')
		if _score_num.nil?
			_score_num = '%05d' % 0
		end
		score = {
				'score' => '%05d' % _score_num,
		}
		render json: score
  end

  def create
    @score = Score.new(score_params)
		if @score.save
			_score_num = '%05d' % score_params[:score]
			_status = "#{score_params[:name]} のスコア #{_score_num} #{TAG}"
			if Score.maximum('score') < score_params[:score].to_i
				_status = " ☆最高得点☆ #{score_params[:name]} のスコア #{_score_num}！！ #{TAG}"
			end
			client = Twitter::REST::Client.new do |config|
				config.consumer_key        = 'nC9zyaLl0ofz3a3gPLSvRlvgT'
				config.consumer_secret     = 'rgxlT8xNcpWsxG4b5bI4VBfR5e7yTjnR8yY5pqN00U17ZHdvy7'
				config.access_token        = '3279813967-7C8CbY97bbJKU81g2UPpK1pAqrOkUAMC8q0YNNq'
				config.access_token_secret = 'oX2T2R5lRc04wSbSUuaVqcPBaPZ9MrQGwt8i1ZjgSKc8Y'
			end
			client.update(_status.to_str)
			_result = true
		else
			_result = false
		end
		render json: _result
	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:name, :score)
    end
end
