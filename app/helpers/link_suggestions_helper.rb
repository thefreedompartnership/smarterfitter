module LinkSuggestionsHelper

  def format_link(link)
    "#{h(link.title)} <br/> #{h(link.link)} <br/> #{h(link.description)} <br/><br/> #{h(link.name)} <br/> #{h(link.email_address)} <br/> #{h(link.website)} <br/>"
  end
end
