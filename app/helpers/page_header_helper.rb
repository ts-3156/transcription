module PageHeaderHelper
  def gradient_header(&block)
    <<~HTML.html_safe
      <header class="page-header page-header-dark bg-gradient-primary-to-secondary">
        #{capture(&block)}
        <div class="svg-border-rounded text-white">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 144.54 17.34" preserveAspectRatio="none" fill="currentColor">
            <path d="M144.54,17.34H0V0H144.54ZM0,0S32.36,17.34,72.27,17.34,144.54,0,144.54,0"></path>
          </svg>
        </div>
      </header>
    HTML
  end
end
