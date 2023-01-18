class ScientistsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index 
        render json: Scientist.all, only: [:id, :name, :field_of_study, :avatar]
    end

    def show 
        scientist = Scientist.find(params[:id])
        render json: scientist, except: [:created_at, :updated_at], include: [planets: {only: [:id, :name, :distance_from_earth, :nearest_star, :image]}] 
    end

    def create 
        scientist = Scientist.create!(scientist_params)
        render json: scientist, status: :created
    end

    def update 
        scientist = Scientist.find(params[:id])
        scientist.update!(scientist_params)
        render json: scientist, status: :accepted
    end

    def destroy 
        scientist = Scientist.find(params[:id])
        scientist.destroy 
        head :no_content
    end



private

    def record_not_found 
        render json: { error: "Scientist not found" }, status: :not_found
    end

    def render_unprocessable_entity_response invalid
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def scientist_params 
        params.permit(:name, :field_of_study, :avatar)
    end
end
