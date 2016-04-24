class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :create_success, :edit, :update, :destroy]
  layout 'yesinsights'
  def index
  end

  def new
    @survey = current_user.surveys.build
    @landing_page = @survey.build_landing_page
    @landing_page.headline = 'Thanks for taking the survey!'
    @landing_page.subtitle = 'If you have a moment, please briefly tell us why.'
    question = @survey.build_question
    3.times do
      question.choices.build
    end

  end

  def create
    @survey = Survey.new(survey_params)
    @survey.user = current_user
    if @survey.save
      redirect_to create_success_survey_path(@survey)
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @survey.update(survey_params)
    redirect_to surveys_path
  end

  def destroy
    @survey.destroy
    redirect_to surveys_path
  end

  def create_success

  end

  def pause

  end

  def resume

  end

  private

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey).permit(
        :name, :notify_enabled,
        question_attributes: [:name, choices_attributes: [:name] ],
        landing_page_attributes: [:headline, :subtitle, :comment_enabled]
    )
  end
end
