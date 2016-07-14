module Shoppe
  class Order < ActiveRecord::Base
    # An array of all the available statuses for an order
    STATUSES = %w(building confirming received accepted rejected shipped canceled returned).freeze

    # The Shoppe::User who accepted the order
    #
    # @return [Shoppe::User]
    belongs_to :accepter, class_name: 'Shoppe::User', foreign_key: 'accepted_by'

    # The Shoppe::User who rejected the order
    #
    # @return [Shoppe::User]
    belongs_to :rejecter, class_name: 'Shoppe::User', foreign_key: 'rejected_by'
    # The Shoppe::User who canceled the order
    #
    # @return [Shoppe::User]
    belongs_to :canceler, class_name: 'Shoppe::User', foreign_key: 'canceled_by'
    # The Shoppe::User who refunded the order
    #
    # @return [Shoppe::User]
    belongs_to :returner, class_name: 'Shoppe::User', foreign_key: 'returned_by'

    # Validations
    validates :status, inclusion: { in: STATUSES }

    # Set the status to building if we don't have a status
    after_initialize { self.status = STATUSES.first if status.blank? }

     # All orders which have been received
    scope :received, -> { where('received_at is not null') }

     #All orders which have status recieve
    scope :received_orders,->{ where(status: "received") } 
    # All orders which have been rejected
    scope :rejected_orders, -> { where(status: "rejected") }

    # All orders which have been accepted
    scope :accepted_orders, -> { where(status: "accepted") }

    # All orders which have been shipped
    scope :shipped_orders, -> { where(status: "shipped" )}

    # All orders which have been canceled
    
    scope :canceled_orders, -> { where(status: "canceled"  )}
    
    # All orders which have been returned
    
    scope :returned_orders, -> {where(status: "returned")}


    # All orders which are currently pending acceptance/rejection
    scope :pending, -> { where(status: 'received') }

    # All ordered ordered by their ID desending
    scope :ordered, -> { order(id: :desc) }

    # Is this order still being built by the user?
    #
    # @return [Boolean]
    def building?
      status == 'building'
    end

    # Is this order in the user confirmation step?
    #
    # @return [Boolean]
    def confirming?
      status == 'confirming'
    end

    # Has this order been rejected?
    #
    # @return [Boolean]
    def rejected?
      !!rejected_at
    end

    # Has this order been canceled?
    #
    # @return [Boolean]
    def canceled?
      !!canceled_at
    end

    # Has this order been returned?
    #
    # @return [Boolean]
    def returned?
      !!returned_at
    end

    # Has this order been accepted?
    #
    # @return [Boolean]
    def accepted?
      !!accepted_at
    end

    # Has the order been received?
    #
    # @return [Boolean]
    def received?
      !!received_at?
    end
  end
end
