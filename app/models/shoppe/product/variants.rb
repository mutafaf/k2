module Shoppe
  class Product < ActiveRecord::Base
    # Validations
    validate { errors.add :base, :can_belong_to_root if parent && parent.parent }

    # Variants of the product
    has_many :variants, class_name: 'Shoppe::Product', foreign_key: 'parent_id', dependent: :destroy

    # The parent product (only applies to variants)
    belongs_to :parent, class_name: 'Shoppe::Product', foreign_key: 'parent_id'

    # All products which are not variants
    scope :root, -> { where(parent_id: nil) }

    # For Soft Deletion
    default_scope-> { where(status: nil) }

    # If a variant is created, the base product should be updated so that it doesn't have stock control enabled
    after_save do
      if parent
        # parent.tax_rate = nil
        # parent.weight = 0

        parent.price = 0
        parent.old_price = 0
        parent.color = ""
        parent.color_name = ""
        parent.sizes.clear
        parent.stock_control = false
        parent.save if parent.changed?
      end
    end

    after_save :make_default_only_one_variant, :check_active_for_default_variant#, :check_active_variant

    # Make default only current variant.
    def make_default_only_one_variant
      if self.variant? and self.default_changed?
        # If there are variants other than default variant.
        if self.parent.variants.count > 1
          self.parent.variants.each do |variant|
            variant.update_column(:default, false)
          end
        end
          # Otherwise current or default variant will be true
         self.update_column(:default, true)
      end
    end

    def check_active_for_default_variant
      if self.variant?  and self.default and self.active_changed?
        # If there are variants other than default variant.
        if self.parent.variants.count > 1
            next_variants = self.parent.variants.where.not(id: self.id)
            go_to_next_variant = true
            next_variants.each do |next_variant|
              if next_variant.active.present? and go_to_next_variant
                self.update_column(:default, false)
                next_variant.update_column(:default, true)
                go_to_next_variant = false
              end
          end

          if go_to_next_variant.present?
            self.parent.update_column(:active, false)
          end
        else
          # Sync active check of Default Variant to its Parent
          self.parent.update_column(:active, self.active)
        end
      end
    end

    # def check_active_variant
    #   if self.variant? and self.active_changed?
    #     self.parent.update_column(:active, true)

    #     active_variants = self.parent.variants.where(active:true)
    #     if active_variants.count == 1
    #       self.update_column(:default, true)
    #     end

    #   end
    # end

    # Does this product have any variants?
    #
    # @return [Boolean]
    def has_variants?
      !variants.empty?
    end

    # Returns the default variant for the product or nil if none exists.
    #
    # @return [Shoppe::Product]
    def default_variant
      return nil if parent
      @default_variant ||= variants.find(&:default?)
    end

    # Is this product a variant of another?
    #
    # @return [Boolean]
    def variant?
      !parent_id.blank?
    end

    #  To override the getter method and unscope super:
    def parent
      Shoppe::Product.unscoped{ super }
    end
  end
end
