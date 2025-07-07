# frozen_string_literal: true

# Helper method that renders icons from different icon libraries.
# Usage:
# = icon('home', size: 'x-large', color: 'primary')
# = flash_icon('notice', size: 'x-large', color: 'primary')
#
# The default library is Material Icons, but can be changed here by pulling
# in a different builder from RoleModel Rails.
# Available libraries:
# - MaterialIconBuilder
# - PhosphorIconBuilder
# - TablerIconBuilder
# - FeatherIconBuilder
# - LucideIconBuilder
# - CustomIconBuilder
module IconHelper
  # duotone, filled, size, weight, additional_classes, color, hover_text
  def icon(name, **)
    PhosphorIconBuilder.new(name, **).build
  end

  # duotone, filled, size, weight, additional_classes, color, hover_text
  def flash_icon(type, **)
    PhosphorIconBuilder.flash_icon(type, **).build
  end
end
