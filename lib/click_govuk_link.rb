
def click_govuk_link(link_text)
  valid_link_classes = ["govuk-link", "govuk-breadcrumbs__link", "govuk-back-link", "govuk-header__link", "govuk-footer__link", "govuk-notification-banner__link", "govuk-skip-link", "govuk-tabs__tab"]

  ambiguous_link_texts = ["Change", "Add", "Remove"]

  links = all('a', text: link_text, exact_text: true)

  if links.size == 0
    links_without_exact_match = all('a', text: link_text)
    links_with_href_match = all(:link, href: link_text)
    links_with_id_match = all(:link, link_text)

    if links_without_exact_match.size > 0
      raise "Unable to find link \"#{link_text}\" but did find link with the text \"#{links_without_exact_match.first.text}\" - include the full link text including any visually-hidden text"
    elsif links_with_href_match.size > 0
      raise "Use the full link text within click_govuk_link() instead of the link href"
    elsif links_with_id_match.size > 0
      raise "Use the full link text within click_govuk_link() instead of the link id"
    else
      raise "Unable to find link \"#{link_text}\""
    end

  elsif links.size > 1
    raise "There are #{links.size} links with the link text \"#{link_text}\" - links should be unique within a page"
  end

  if ambiguous_link_texts.include?(link_text.strip)
    raise "The link was found, but the text \"#{link_text}\" is ambiguous if heard out of context - add some visually-hidden text"
  end

  link = links.first

  link_classes = link[:class].to_s.split(/\s/).collect(&:strip)

  if link_classes.include?('govuk-button')
    raise "The link was found, but is styled as a button. Use `click_govuk_button` instead."
  end

  if link[:target] == "_blank" && !link_text.include?("opens in new tab")
    raise "The link was found, but is set to open in a new tab. Either remove this, or add \"(opens in new tab)\" to the link text"
  end

  if link_classes.any? {|link_class| valid_link_classes.include?(link_class) }
    link.click
  elsif link_classes.empty?
    raise "\"#{link_text}\" link is missing a class, should contain \"govuk-link\""
  else
    raise "\"#{link_text}\" link is missing a govuk-link class, contains #{link_classes.join(', ')}"
  end
end
