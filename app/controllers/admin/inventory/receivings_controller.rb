class Admin::Inventory::ReceivingsController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  def index
    # by default find all POs that are not received
    @purchase_orders = PurchaseOrder.receiving_admin_grid(params).order(sort_column + " " + sort_direction).
                                                        paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  #def new
  #end

  #def create
  #end

  def edit
    @purchase_order = PurchaseOrder.includes([:variants ,
                                              :supplier,
                                              {:purchase_order_variants => {:variant => :product }}]).find(params[:id])
    form_info
  end

  def update
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      if @purchase_order.update_attributes(params[:purchase_order])
        format.html { redirect_to(:action => :index, :notice => 'Purchase order was successfully updated.') }
      else
        form_info
        format.html { render :action => "edit" }
      end
    end
  end

  def show
  end

private
  def form_info

  end
  def pagination_rows
    params[:rows] ||= 25
    params[:rows].to_i
  end

  def sort_column
    return 'suppliers.name' if params[:sort] == 'supplier_name'
    PurchaseOrder.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
