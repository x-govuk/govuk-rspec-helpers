RSpec::Matchers.define :summarise_errors do |expected|
  match do |_actual|
    title_contains_prefix &&
    error_summary_title &&
    expected.all? do |expected_error|
      error_messages && error_messages[expected.index(expected_error)] == expected_error
    end && expected.size == error_messages.size &&
    all_error_messages_contain_links &&
    all_error_messages_links_are_valid
  end

  failure_message do |actual|
    missing_error = expected.find {|expected_error| !error_messages.include?(expected_error) }
    if !title
      "Missing <title> tag"
    elsif !title_contains_prefix
      "Title tag is missing the error prefix: ‘#{title}’"
    elsif !error_summary_title
      "Missing an error summary title"
    elsif missing_error
      "Missing error message: ‘#{missing_error}’"
    elsif !all_error_messages_contain_links
      "Error message ‘#{error_message_missing_link}’ isn’t linked to anything"
    elsif !all_error_messages_links_are_valid
      "Error message ‘#{error_message_with_invalid_link.text(normalize_ws: true)}’ links to ##{error_message_with_invalid_link[:href].split('#').last} but no input field has this ID or name"
    elsif expected.size == error_messages.size
      "Error messages appear in a different order"
    elsif expected.size < error_messages.size
      "An extra error message is present"
    else
      "Unexpected error"
    end
  end

  def html
    @html ||= Capybara::Node::Simple.new(actual.is_a?(String) ? actual : actual.to_html)
  end

  def title
    @title ||= html.title
  end

  def title_contains_prefix
    title.to_s.start_with?("Error: ")
  end

  def all_error_messages_contain_links
    error_message_items.all? do |error_message_item|
      error_message_item.all(:link).first
    end
  end

  def all_error_messages_links_are_valid
    error_message_items.all? do |error_message_item|
      link = error_message_item.all(:link).first

      if link
        link_fragment = link[:href].split('#').last

        link_target= html.all(id: link_fragment).first || html.all(:field, name: link_fragment).first

        link_target
      else
        false
      end
    end
  end

  def error_message_with_invalid_link
    invalid_link = error_message_links.find do |error_message_link|
      link_fragment = error_message_link[:href].split('#').last

      link_target= html.all(id: link_fragment).first || html.all(:field, name: link_fragment).first

      !link_target
    end
  end

  def error_message_missing_link
    error_message_items.find do |error_message_item|
      !error_message_item.all(:link).first
    end.text(normalize_ws: true)
  end

  def error_messages
    @error_messages ||= (error_summary_list && error_summary_list.all('li').collect {|li| li.text(normalize_ws: true) } || [])
  end

  def error_message_links
    @error_message_links ||= error_message_items.collect {|item| item.all(:link).first }
  end

  def error_message_items
    @error_message_items ||= (error_summary_list && error_summary_list.all('li') || [])
  end

  def error_summary_list
    @error_summary_list ||= (error_summary && error_summary.all('.govuk-error-summary__list').first)
  end

  def error_summary_title
    @error_summary_title ||= error_summary.all('h2.govuk-error-summary__title').first
  end

  def error_summary
    @error_summary ||= html.all('.govuk-error-summary').first
  end

end
