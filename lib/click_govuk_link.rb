module GovukRspecHelpers
  class ClickLink

    attr_reader :link_text, :page

    VALID_LINK_CLASSES = ["govuk-link", "govuk-breadcrumbs__link", "govuk-back-link", "govuk-header__link", "govuk-footer__link", "govuk-notification-banner__link", "govuk-skip-link", "govuk-tabs__tab"]

    AMIBIGOUS_LINK_TEXTS = ["Change", "Add", "Remove"]

    def initialize(page:, link_text:)
      @page = page
      @link_text = link_text
    end

    def click
      @links = page.all('a', text: link_text, exact_text: true, normalize_ws: true)

      if @links.size == 0
        check_whether_there_is_an_inexact_match
        check_whether_there_is_an_href_match
        check_whether_there_is_an_id_match

        raise "Unable to find link \"#{link_text}\""
      end

      check_link_text_is_unique
      check_link_text_is_not_ambiguous

      @link = @links.first
      @link_classes = @link[:class].to_s.split(/\s/).collect(&:strip)

      check_link_is_not_styled_as_button
      check_link_warns_if_opening_in_a_new_tab
      check_link_does_not_contain_a_button
      check_link_has_a_valid_class

      @link.click
    end

    private

    def check_whether_there_is_an_inexact_match
      links_without_exact_match = page.all('a', text: link_text)
      if page.all('a', text: link_text).size > 0
        raise "Unable to find link \"#{link_text}\" but did find link with the text \"#{links_without_exact_match.first.text}\" - include the full link text including any visually-hidden text"
      end
    end

    def check_whether_there_is_an_href_match
      links_with_href_match = page.all(:link, href: link_text)
      if links_with_href_match.size > 0
        raise "Use the full link text within click_govuk_link() instead of the link href"
      end
    end

    def check_whether_there_is_an_id_match
      links_with_id_match = page.all(:link, link_text)
      if links_with_id_match.size > 0
        raise "Use the full link text within click_govuk_link() instead of the link id"
      end
    end

    def check_link_text_is_not_ambiguous
      if AMIBIGOUS_LINK_TEXTS.include?(link_text.strip)
        raise "The link was found, but the text \"#{link_text}\" is ambiguous if heard out of context - add some visually-hidden text"
      end
    end

    def check_link_text_is_unique
      if @links.size > 1
        raise "There are #{@links.size} links with the link text \"#{link_text}\" - links should be unique within a page"
      end
    end

    def check_link_is_not_styled_as_button
      if @link_classes.include?('govuk-button')
        raise "The link was found, but is styled as a button. Use `click_govuk_button` instead."
      end
    end

    def check_link_warns_if_opening_in_a_new_tab
      if @link[:target] == "_blank" && !link_text.include?("opens in new tab")
        raise "The link was found, but is set to open in a new tab. Either remove this, or add \"(opens in new tab)\" to the link text"
      end
    end

    def check_link_does_not_contain_a_button
      if @link.all('button').any?
        raise "The link was found, but it contains a button – use either a link or button but not both"
      end
    end

    def check_link_has_a_valid_class
      if @link_classes.empty?
        raise "\"#{link_text}\" link is missing a class, should contain \"govuk-link\""
      elsif !@link_classes.any? {|link_class| VALID_LINK_CLASSES.include?(link_class) }
        raise "\"#{link_text}\" link is missing a govuk-link class, contains #{@link_classes.join(', ')}"
      end
    end
  end

  def click_govuk_link(link_text)
    ClickLink.new(page: page, link_text: link_text).click
  end

  RSpec.configure do |rspec|
    rspec.include self
  end

end
