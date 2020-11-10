$(document).on('turbolinks:load', function(){
  $('.edit_answer').on('click', editorLinkHandler)
});

function editorLinkHandler(e) {
  e.preventDefault()
  let answerId = this.dataset.answerId
  var editForm = $('form#edit-answer-' + answerId)
  editForm.removeClass('d-none')
  $(this).addClass('d-none')
  console.log(editForm)
}
