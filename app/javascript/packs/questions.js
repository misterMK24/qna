$(document).on('turbolinks:load', function(){
  $('.edit_question').on('click', editorLinkHandler)
});

function editorLinkHandler(e) {
  e.preventDefault()
  var editForm = $('form#question_edit')
  editForm.removeClass('d-none')
  $(this).addClass('d-none')
}
