# coding: utf-8
# simply require this file to enable Comfortable Mexican Sofa integration
# read more https://github.com/glebm/rails_email_preview/wiki/Edit-Emails-with-Comfortable-Mexican-Sofa

module RailsEmailPreview
  module Integrations
    module ComfortableMexicanSofa
      # @return [String] CMS identifier for the current email
      # ModerationMailer#approve -> "moderation_mailer-approve"
      def cms_email_id
        mailer = respond_to?(:controller) ? controller : self
        "#{mailer.class.name.underscore.gsub('/', '__')}-#{action_name}"
      end

      # @param [Hash] interpolation subject interpolation values
      # @return [String] Snippet title interpolated with passed variables
      #
      # For a snippet with title "Welcome, %{name}!"
      #     cms_email_subject(name: "Alice") #=> "Welcome, Alice!"
      def cms_email_subject(interpolation = {})
        snippet_id = "email-#{cms_email_id}"
        return '(no subject)' unless cms_snippet_class.where(identifier: snippet_id).exists?
        [I18n.locale, I18n.default_locale].compact.each do |locale|
          site = cms_site_class.find_by_locale(locale.to_s)
          unless site
            raise "rails_email_preview: #{t 'integrations.cms.errors.site_missing', locale: locale}"
          end
          snippet = site.snippets.find_by_identifier(snippet_id)
          next unless snippet.try(:content).present?

          # interpolate even if keys/values are missing
          title         = snippet.label.to_s
          interpolation = interpolation.stringify_keys
          # set all missing values to ''
          title.scan(/%{([^}]+)}/) { |m| interpolation[m[0]] ||= '' }
          # remove all missing keys
          subject = title % interpolation.symbolize_keys.delete_if { |k, v| title !~ /%{#{k}}/ }

          return subject if subject.present?
        end
        '(no subject)'
      end

      # show edit link?
      def cms_email_edit_link?
        RequestStore.store[:rep_edit_links]
      end

      def cms_email_edit_link(site, default_site, snippet_id)
        snippet   = site.snippets.find_by_identifier(snippet_id) || cms_snippet_class.new(
            label:      "#{snippet_id.sub('-', ' / ').humanize}",
            identifier: snippet_id,
            site:       site
        )
        p         = {site_id: site.id}
        edit_path = if snippet.persisted?
                      p[:id] = snippet.id
                      if snippet.content.blank? && default_site && (default_snippet = default_site.snippets.find_by_identifier(snippet_id))
                        p[:snippet]         = {
                            content: default_snippet.content
                        }
                        p[:snippet][:label] = default_snippet.label unless snippet.label.present?
                      end
                      send :"edit_#{cms_admin_site_snippet_route}_url",
                           p.merge(only_path: true)
                    else
                      p[:snippet] = {
                          label:        snippet.label,
                          identifier:   snippet.identifier,
                          category_ids: [site.categories.find_by_label('email').try(:id)]
                      }
                      send :"new_#{cms_admin_site_snippet_route}_url",
                           p.merge(only_path: true)
                    end
        <<-HTML.strip.html_safe
          <table class='rep-edit-link'><tr><td>
            #{cms_edit_email_snippet_link(edit_path)}
          </td></tr></table>
        HTML
      end

      # @return [String] Snippet content, passed through Kramdown.
      # Also renders an "✎ Edit" link inside the email when called from preview
      def cms_email_snippet(snippet_id = self.cms_email_id)
        snippet_id   = "email-#{snippet_id}"
        site         = cms_site_class.find_by_locale(I18n.locale.to_s)
        default_site = cms_site_class.find_by_locale(I18n.default_locale.to_s)

        if cms_snippet_class.where(identifier: snippet_id).exists?
          # Prefill from default locale if no content
          content = send(cms_snippet_render_method, snippet_id, site)
          result  = (content.presence || send(cms_snippet_render_method, snippet_id, default_site)).to_s
        else
          result = ''
        end

        # If rendering in preview from admin, add edit/create link
        if cms_email_edit_link?
          result = safe_join [cms_email_edit_link(site, default_site, snippet_id), result], "\n\n"
        end
        result
      end

      def cms_edit_email_snippet_link(path)
        link_to(RailsEmailPreview.edit_link_text, path, style: RailsEmailPreview.edit_link_style.html_safe)
      end

      def self.rep_email_params_from_snippet(snippet)
        id_prefix = 'email-'
        return unless snippet && snippet.identifier && snippet.identifier.starts_with?(id_prefix)
        mailer_cl, act = snippet.identifier[id_prefix.length..-1].split('-')
        {preview_id:   "#{mailer_cl}_preview-#{act}",
         email_locale: snippet.site.locale}
      end

      module CmsVersionsCompatibility
        def cms_admin_site_snippet_route
          if cms_version_gte?('1.11.0')
            :comfy_admin_cms_site_snippet
          else
            :admin_cms_site_snippet
          end
        end

        def cms_snippet_class
          if cms_version_gte?('1.12.0')
            ::Comfy::Cms::Snippet
          else
            ::Cms::Snippet
          end
        end

        def cms_site_class
          if cms_version_gte?('1.12.0')
            ::Comfy::Cms::Site
          else
            ::Cms::Site
          end
        end

        def cms_snippet_render_method
          if cms_version_gte?('1.12.0')
            :cms_snippet_render
          else
            :cms_snippet_content
          end
        end

        def cms_v2_plus?
          cms_version_gte? '2.0.0'
        end

        private
        def cms_version_gte?(version)
          (::ComfortableMexicanSofa::VERSION.split('.').map(&:to_i) <=> version.split('.').map(&:to_i)) >= 0
        end
      end

      extend CmsVersionsCompatibility
      include CmsVersionsCompatibility
      include ::Comfy::CmsHelper if cms_version_gte?('1.12.4')
    end
  end
end

ActionMailer::Base.module_eval do
  include ::RailsEmailPreview::Integrations::ComfortableMexicanSofa
  helper ::RailsEmailPreview::Integrations::ComfortableMexicanSofa
end

require 'comfortable_mexican_sofa'
ComfortableMexicanSofa::ViewHooks.add :navigation, 'integrations/cms/customize_cms_for_rails_email_preview'
