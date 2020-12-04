document.addEventListener('turbolinks:load', function() {
  let editQuestionElement = document.querySelector('.edit_question')

  if (editQuestionElement) { editQuestionElement.addEventListener('click', editorLinkHandler) }
})

function editorLinkHandler(e) {
     e.preventDefault()
     var editForm = document.querySelector('form#question_edit')
     editForm.classList.remove('d-none')
     this.classList.add('d-none')
}
