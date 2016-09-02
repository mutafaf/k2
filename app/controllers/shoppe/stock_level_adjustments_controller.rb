module Shoppe
  class StockLevelAdjustmentsController < ApplicationController
    SUITABLE_OBJECTS = ['Shoppe::Product'].freeze
    before_filter :suitable_objects, except: [:export, :import]

    def index
      @stock_level_adjustments = @item.stock_level_adjustments.ordered.page(params[:page]).per(10)
      @new_sla = @item.stock_level_adjustments.build if @new_sla.nil?
      render action: 'index', layout: false if request.xhr?
    end

    def create
      @new_sla = @item.stock_level_adjustments.build(params[:stock_level_adjustment].permit(:description, :adjustment, :size_id))
      if @new_sla.save
        if request.xhr?
          @new_sla = @item.stock_level_adjustments.build
          index
        else
          redirect_to stock_level_adjustments_path(item_id: params[:item_id], item_type: params[:item_type]), notice: t('shoppe.stock_level_adjustments.create_notice')
        end
      else
        if request.xhr?
          render text: @new_sla.errors.full_messages.to_sentence, status: 422
        else
          index
          flash.now[:alert] = @new_sla.errors.full_messages.to_sentence
          render action: 'index'
        end
      end
    end

    def view_stock
      @sizes = Shoppe::Size.all
      @variants = @item.get_variants

      render action: 'view_stock', layout: false if request.xhr?
    end

    def export
      begin
        respond_to do |format|
          format.xls{
            path = StringIO.new
            book = StockLevelAdjustment.to_xls()
            book.write path
            send_data path.string, :filename => "Stock List.xls", :type =>  "application/excel"
          }
        end
      rescue => ex
        redirect_to "/admin", :notice =>ex.message
      end
    end

    def import
      if request.post?
        if params[:import].nil?
          redirect_to products_path, flash: { alert: t('shoppe.imports.errors.no_file') }
        else
          Shoppe::StockLevelAdjustment.import(params[:import][:import_file])
          redirect_to products_path, flash: { notice: t('shoppe.stock_level_adjustments.imports.success') }
        end
      end
    end




    private

    def suitable_objects
      fail Shoppe::Error, t('shoppe.stock_level_adjustments.invalid_item_type', suitable_objects:  SUITABLE_OBJECTS.to_sentence) unless SUITABLE_OBJECTS.include?(params[:item_type])
      @item = params[:item_type].constantize.find(params[:item_id].to_i)

      params[:id] && @sla = @item.stock_level_adjustments.find(params[:id].to_i)
    end

  end
end
