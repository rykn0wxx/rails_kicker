module NavbarHelper

  # Usage:
  #   <%= navbar_link_to(
  #     "Home",
  #     root_path,
  #     active_when: { controller: "home" }) %>

  def navbar_link_to(label, path, options={})

    active_when = options.delete(:active_when) { Hash.new }
    active = active_when.all? do |key, value|
      case value
      when Regexp
        params[key].to_s =~ value
      else
        params[key].to_s == value
      end
    end

    content_tag(:li, :class => ('active' if active)) do
      link_to(label, path, options)
    end

  end

end