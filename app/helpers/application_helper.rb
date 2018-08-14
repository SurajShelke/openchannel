module ApplicationHelper
  def is_path?(paths)
    is_path = false
    paths.each do |path|
      recognized = Rails.application.routes.recognize_path(path)
      if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
        is_path = true
      end
    end
    is_path
  end

  def valid_url(url)
    url.include?('watch?v=') ? url.sub('watch?v=','embed/') : url
  end

  def visit_website_url(provided_website)
    return "" if provided_website.blank?
    unless (['http', 'https'].include?(URI.parse(provided_website).scheme) rescue false)
      provided_website = "http://"+provided_website
    end
    provided_website
  end

  def allowed_categories
    ['Accounting', 'Analytics', 'Automation', 'Booking & Ticketing', 'Card Readers & POS', 'CRM', 'Customer Support', 'E-Commerce', 'Electronic Signature', 'Email Marketing & Dunning', 'Financing', 'Form Building', 'Fundraising', 'Gift Certificates', 'Inventory Management', 'Invoicing']
  end
end
