class ScoresController < ApplicationController
	TAG = 'It’s being held at Leap Motion 3D Jam 2015. http://goo.gl/RL6wKG'
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
		_score_params = {
				:name => score_params['score'][0]['name'],
				:score => score_params['score'][0]['score']
		}
    @score = Score.new(_score_params)
		if @score.save
			_score_num = '%05d' % _score_params[:score]
			_status = “.#{_score_params[:name]}’s score is 『#{_score_num}』 #{TAG}"
			if Score.maximum('score') < _score_params[:score].to_i
				_status = " ☆The highest score☆ .#{_score_params[:name]}’s score is 『#{_score_num}』！！ #{TAG}"
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
      params.permit(:score => [:name, :score])
    end
end
