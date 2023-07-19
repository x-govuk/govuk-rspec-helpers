RSpec::Matchers.define :have_descriptive_links do |expected|
  match do |_actual|
    !ambiguous_link &&
    no_duplicates
  end

  failure_message do |actual|
    if ambiguous_link
      "The link ‘#{ambiguous_link}’ is not clear enough out of context. Add extra text to make the link purpose clear. This can be visually-hidden if needed."
    elsif duplicate_link
      "There are #{link_texts.count(duplicate_link)} links with the link text ‘#{duplicate_link}’. Link texts should be unique across a page."
    else
      "Unexpected error"
    end
  end

  def ambiguous_link
    @ambiguous_links ||= link_texts.find do |link_text|
      ambiguous_link_texts.include?(link_text)
    end
  end

  def no_duplicates
    link_texts.uniq.size == link_texts.size
  end

  def duplicate_link
    link_texts.detect {|link_text| link_texts.count(link_text) > 1 }
  end

  def link_texts
    @link_texts = links.collect {|link| link.text(normalize_ws: true) }
  end

  def ambiguous_link_texts
    ['Change', 'Hide', 'Edit', 'Add']
  end

  def links
    @links ||= html.all(:link)
  end

  def html
    @html ||= Capybara::Node::Simple.new(actual.is_a?(String) ? actual : actual.to_html)
  end


end
