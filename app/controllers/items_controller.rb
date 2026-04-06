class ItemsController < ApplicationController

  #http_basic_authenticate_with name: USER_ID, password: PASSWORD, except: [:index, :show]
  #before_filter :authenticate, :except => [:index, :show]

  before_action :authenticate_user!, :except => [:show, :index, :search]

  def index
    @items = Item.all.page params[:page]
  end

  # Show action
  def show
    @item = Item.find(params[:id])
  end

  # New action
  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  # Create action
  def create
    #render plain: params[:items].inspect
    @item = Item.new(item_params)

    if @item.save
      redirect_to @item
    else
      render 'new'
    end
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    #@item.avatar = nil
    #@item.save

    redirect_to items_path
  end

  # GET /books/search
  # GET /books/search.xml
  def search
    @items = Item.search do
      keywords params[:query]
    end.results

    render 'index'

    # respond_to do |format|
    #   format.html { render :action => "index" }
    #   format.xml  { render :xml => @books }
    # end
  end

  def avatar
    @item = Item.find(params[:id])
    @item.trainimage.purge
    redirect_to edit_item_path(@item)
  end

  private
    def item_params
      params.require(:item).permit(:title, :text, :trainimage, :scale, :inbox, :sn, :brand, :sellprice, :selldate, :dateval_date, :dateval)
    end

end
