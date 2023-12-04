class TitleCountComponent < ViewComponent::Base
  def initialize(title:, count:)
    super
    @title = title
    @count = count
  end

  def call
    content_tag :h1, id: 'count',
                     class: 'font-bold px-12 py-2 flex flex-nowrap gap-4 bg-slate-950 rounded-xl shadow-lg shadow-gray-950' do
      concat content_tag(:span, title_with_count, class: 'text-left text-slate-200 md:text-lg lg:text-xl xl:text-4xl')
    end
  end

  private

  def title_with_count
    I18n.t("counter.#{@title}", count: @count)
  end
end
