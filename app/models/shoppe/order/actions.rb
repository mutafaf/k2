module Shoppe
  class Order < ActiveRecord::Base
    extend ActiveModel::Callbacks

    # These additional callbacks allow for applications to hook into other
    # parts of the order lifecycle.
    define_model_callbacks :confirmation, :acceptance, :rejection, :cancelation, :return

    # This method should be called by the base application when the user has completed their
    # first round of entering details. This will mark the order as "confirming" which means
    # the customer now just must confirm.
    #
    # @param params [Hash] a hash of order attributes
    # @return [Boolean]
    def proceed_to_confirm(params = {})
      self.status = 'confirming'
      if update(params)
        true
      else
        false
      end
    end

    # This method should be executed by the application when the order should be completed
    # by the customer. It will raise exceptions if anything goes wrong or return true if
    # the order has been confirmed successfully
    #
    # @return [Boolean]
    def confirm!
      no_stock_of = order_items.select(&:validate_stock_levels)
      unless no_stock_of.empty?
        fail Shoppe::Errors::InsufficientStockToFulfil, order: self, out_of_stock_items: no_stock_of
      end

      run_callbacks :confirmation do
        # If we have successfully charged the card (i.e. no exception) we can go ahead and mark this
        # order as 'received' which means it can be accepted by staff.
        self.status = 'received'
        self.received_at = Time.now
        save!

        order_items.each(&:confirm!)

        # Send an email to the customer
        deliver_received_order_email
      end

      # We're all good.
      true
    end

    # Mark order as accepted
    #
    # @param user [Shoppe::User] the user who carried out this action
    def accept!(user = nil)
      run_callbacks :acceptance do
        self.accepted_at = Time.now
        self.accepter = user if user
        self.status = 'accepted'
        save!
        order_items.each(&:accept!)
        deliver_accepted_order_email
      end
    end

    # Mark order as rejected
    #
    # @param user [Shoppe::User] the user who carried out the action
    def reject!(user = nil)
      run_callbacks :rejection do
        self.rejected_at = Time.now
        self.rejecter = user if user
        self.status = 'rejected'
        save!
        order_items.each(&:reject!)
        deliver_rejected_order_email
      end
    end

    # Mark order as canceled
    #
    # @param user [Shoppe::User] the user who carried out the action
    def cancel!(user = nil)
      run_callbacks :cancelation do
        self.canceled_at = Time.now
        self.canceler = user if user
        self.status = 'canceled'
        save!
        order_items.each(&:cancel!)
        deliver_canceled_order_email
      end
    end

    # Mark order as canceled
    #
    # @param user [Shoppe::User] the user who carried out the action
    def return!(user = nil)
      # Returned
      run_callbacks :return do
        self.returned_at = Time.now ###
        self.returner = user if user
        self.status = 'returned'
        save!
        order_items.each(&:return!)
        deliver_returned_order_email
      end
    end

    def deliver_accepted_order_email
      Shoppe::OrderMailer.accepted(self).deliver
    end

    def deliver_rejected_order_email
      Shoppe::OrderMailer.rejected(self).deliver
    end

    def deliver_canceled_order_email
      Shoppe::OrderMailer.canceled(self).deliver
    end

    def deliver_returned_order_email
      Shoppe::OrderMailer.returned(self).deliver
    end

    def deliver_received_order_email
      Shoppe::OrderMailer.delay.received(self)
      # Shoppe::OrderMailer.received(self).deliver
    end
  end
end
