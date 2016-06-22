module Shoppe::JobsHelper
  def format_date(date)
    date.strftime("%b %d, %Y")
  end
    def format_datetime(date)
    date.strftime("%b %d, %Y at %I:%M %p")
  end
end
