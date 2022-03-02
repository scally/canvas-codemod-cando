require_relative '../app/replace_can_use'

describe 'ReplaceCanUse' do
  def subject
    source = RuboCop::ProcessedSource.new code, 2.7
    rewriter = ReplaceCanUse.new
    rewriter.rewrite source.buffer, source.ast
  end

  describe 'first context' do
    def code() = 'can_do(@context.groups.temp_record, @current_user, :create)'
    def expected() = '@context.groups.temp_record&.grants_any_right?(@current_user, session, :create)'

    it { expect(subject).must_equal expected }
  end

  describe 'another context' do
    def code
      <<-HEREDOC
        if can_do(@portfolio, @current_user, :update)
          content_for_head helpers.auto_discovery_link_tag(:atom, feeds_eportfolio_path(@portfolio.id, :atom, verifier: @portfolio.uuid), { title: t("titles.feed", "Eportfolio Atom Feed") })
        elsif @portfolio.public
          content_for_head helpers.auto_discovery_link_tag(:atom, feeds_eportfolio_path(@portfolio.id, :atom), { title: t("titles.feed", "Eportfolio Atom Feed") })
        end
      HEREDOC
    end

    def expected
      <<-HEREDOC
        if @portfolio&.grants_any_right?(@current_user, session, :update)
          content_for_head helpers.auto_discovery_link_tag(:atom, feeds_eportfolio_path(@portfolio.id, :atom, verifier: @portfolio.uuid), { title: t("titles.feed", "Eportfolio Atom Feed") })
        elsif @portfolio.public
          content_for_head helpers.auto_discovery_link_tag(:atom, feeds_eportfolio_path(@portfolio.id, :atom), { title: t("titles.feed", "Eportfolio Atom Feed") })
        end
      HEREDOC
    end

    it { expect(subject).must_equal expected }
  end
end
