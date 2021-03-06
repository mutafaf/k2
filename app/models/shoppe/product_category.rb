require 'awesome_nested_set'

module Shoppe
  class ProductCategory < ActiveRecord::Base
    # Allow the nesting of product categories
    # :restrict_with_exception relies on a fix to the awesome_nested_set gem
    # which has been referenced in the Gemfile as we can't add a dependency
    # to a branch in the .gemspec
    acts_as_nested_set  dependent: :restrict_with_exception,
                        after_move: :set_ancestral_permalink,
                        :order_column => :position

    self.table_name = 'shoppe_product_categories'

    # Attachments for this product category
    has_many :attachments, as: :parent, dependent: :destroy, class_name: 'Shoppe::Attachment'

    # All products within this category
    has_many :product_categorizations, dependent: :restrict_with_exception, class_name: 'Shoppe::ProductCategorization', inverse_of: :product_category
    has_many :products, class_name: 'Shoppe::Product', through: :product_categorizations

    # Validations
    validates :name, presence: true
    validates :permalink, presence: true, uniqueness: { scope: :parent_id }, permalink: true
    # validates :permalink, presence: true, uniqueness: true, permalink: true

    # For Soft Deletion
    default_scope -> { where(status: nil) }

    # Root (no parent) product categories only
    scope :without_parent, -> { where(parent_id: nil) }

    # No descendants
    scope :except_descendants, ->(record) { where.not(id: (Array.new(record.descendants) << record).flatten) }

    translates :name, :permalink, :description
    scope :ordered, -> { includes(:translations).order(:name) }

    scope :custom_ordered, -> { includes(:translations).order(:position) }

    # Set the permalink on callback
    before_validation :set_permalink, :set_ancestral_permalink
    after_save :set_child_permalinks
    before_save :alter_category_position
    validates_presence_of :homepage_title, :if => lambda { |o| o.view_on_homepage == true }

    def alter_category_position
      other_category=self.siblings.where(:position => self.position)
      if other_category.present? and self.position_changed?
        current_category = Shoppe::ProductCategory.find(self.id)
        this_position=current_category.position
        if this_position == current_category.position
          other_category=Shoppe::ProductCategory.find(other_category.first.id)
          other_category.update_column(:position, 999)
        else
          other_category=Shoppe::ProductCategory.find(other_category.first.id)
          other_category.update_column(:position, this_position)
        end
      end
    end


    def attachments=(attrs)
      attachments.build(attrs['homepage_image']) if attrs['homepage_image']['file'].present?
      attachments.build(attrs['background_image']) if attrs['background_image']['file'].present?
      attachments.build(attrs['image']) if attrs['image']['file'].present?
    end

    def combined_permalink
      if permalink_includes_ancestors && ancestral_permalink.present?
        "#{ancestral_permalink}/#{permalink}"
      else
        permalink
      end
    end

    # Return array with all the product category parents hierarchy
    # in descending order
    def hierarchy_array
      return [self] unless parent
      parent.hierarchy_array.concat [self]
    end

    def get_category_sequence
      sequence  = self.hierarchy_array.collect(&:name)
      current_category = sequence.slice(-1)
      sequence = sequence.slice(0, sequence.length-1).join("/")
      return current_category unless sequence.present?
      return [current_category, " ( ", sequence, " )"].join

      # return self.hierarchy_array.collect(&:name)
    end

    # Attachment with the role image
    #
    # @return [String]
    def image
      attachments.for('image')
    end


    # Return attachment for the background_image role
    #
    # @return [String]
    def background_image
      attachments.for('background_image')
    end

    # Set attachment for the background_image role
    def background_image_file=(file)
      attachments.build(file: file, role: 'background_image')
    end

    # Return attachment for the background_image role
    #
    # @return [String]
    def homepage_image
      attachments.for('homepage_image')
    end

    # Set attachment for the homepage_image role
    def homepage_image_file=(file)
      attachments.build(file: file, role: 'homepage_image')
    end


    def self.get_featured_categories
      where(view_on_homepage: true).limit(5).order("home_categories_position")
    end

    def self.search_category(category_name)
      joins(:translations).where("shoppe_product_category_translations.name LIKE ?" , "%#{category_name}%").try(:first)
    end

    def self.search_home_category(category_name)
      joins(:translations).where("LOWER(shoppe_product_category_translations.name) LIKE ?" , "%#{category_name}%".downcase).try(:last)
    end

    private

    def set_permalink
      self.permalink = name.parameterize if permalink.blank? && name.is_a?(String)
    end

    def set_ancestral_permalink
      permalinks = []
      ancestors.each do |category|
        permalinks << category.permalink
      end
      self.ancestral_permalink = permalinks.join '/'
    end

    def set_child_permalinks
      children.each(&:save!)
    end
  end
end
