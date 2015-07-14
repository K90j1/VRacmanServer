class ScoresController < ApplicationController
	protect_from_forgery :except => :create

	def index
		@scores = Score.all
	end

	def show
		@score = Score.maximum('score')
		if @score == 0
			@score = 0
		end
		score = {
				'score' => @score,
		}
		render json: score
  end

  def create
    @score = Score.new(score_params)
		render json: score_params

    # respond_to do |format|
      if @score.save
        # format.html { redirect_to @score, notice: 'Score was successfully created.' }
        # format.json { render action: 'show', status: :created, location: @score }
      # else
        # format.html { render action: 'new' }
        # format.json { render json: @score.errors, status: :unprocessable_entity }
      end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:name, :score)
    end
end
