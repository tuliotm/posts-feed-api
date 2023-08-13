# frozen_string_literal: true

class PublicationsController < ApplicationController
  before_action :authorize
  before_action :set_publication, only: %i[show update destroy]

  # GET /publications
  def index
    if params[:page].present? && params[:per_page].present?
      @publications = Publication.page(params[:page]).per(params[:per_page])
    else
      @publications = Publication.all
    end

    render json: { publications: ActiveModel::Serializer::CollectionSerializer.new(@publications, each_serializer: PublicationSerializer) }
  end

  # GET /publications/1
  def show
    render json: { publication: PublicationSerializer.new(@publication) }
  end  

  # POST /publications
  def create
    @publication = Publication.new(publication_params)
    @publication.user = @user

    if @publication.save
      render json: { publication: PublicationSerializer.new(@publication) }, status: :created, location: @publication
    else
      render json: @publication.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /publications/1
  def update
    if @publication.user == @user
      if @publication.update(publication_params)
        render json: { publication: PublicationSerializer.new(@publication) }
      else
        render json: @publication.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Você não tem permissão para editar esta publicação' }, status: :forbidden
    end
  end

  # DELETE /publications/1
  def destroy
    if @publication.user == @user
      @publication.destroy
    else
      render json: { error: 'Você não tem permissão para excluir esta publicação' }, status: :forbidden
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publication
    @publication = Publication.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def publication_params
    params.require(:publication).permit(:title, :description, :file)
  end
end
