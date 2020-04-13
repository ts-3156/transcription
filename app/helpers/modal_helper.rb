module ModalHelper
  def modal_trigger(target:, &block)
    content_tag 'span', style: 'cursor : pointer;', data: {target: target, toggle: 'modal'}, &block
  end

  def modal_dialog(id:, title:, body:, button: nil)
    button = {positive: 'OK'} unless button
    <<~HTML.html_safe
      <div class="modal fade" id="#{id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">#{title}</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              #{body}
            </div>
            <div class="modal-footer">
              #{modal_negative_button(buttion[:negative]) if button[:negative]}
              <button type="button" class="btn btn-primary" data-dismiss="modal">#{button[:positive]}</button>
            </div>
          </div>
        </div>
      </div>
    HTML
  end

  def modal_negative_button(label)
    <<~HTML.html_safe
      <button type="button" class="btn btn-secondary" data-dismiss="modal">#{label}</button>
    HTML
  end
end
