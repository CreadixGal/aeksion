class TitleCountComponent < ViewComponent::Base
  def initialize(title:, count:)
    super
    @title = title
    @count = count
  end

  def call
    content_tag :h1, id: 'count',
                     class: 'w-full font-bold px-12 py-2 flex flex-nowrap gap-4 my-12' do
      concat content_tag(:span, title_with_count, class: 'text-left text-black md:text-lg lg:text-xl xl:text-4xl')
    end
  end

  private

  def title_with_count
    I18n.t("counter.#{@title}", count: @count)
  end
end
