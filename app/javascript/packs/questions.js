document.addEventListener('turbolinks:load', function() {
  let editQuestionElement = document.querySelector('.edit_question')
  let newQuestionCommentElement = document.querySelector('.btn_new_question_comment')

  if (editQuestionElement) { editQuestionElement.addEventListener('click', editorLinkHandler) }
  if (newQuestionCommentElement) { newQuestionCommentElement.addEventListener('click', newCommentForm) }
})

function editorLinkHandler(e) {
     e.preventDefault()
     var editForm = document.querySelector('form#question_edit')
     editForm.classList.remove('d-none')
     this.classList.add('d-none')
}

function newCommentForm(e) {
  e.preventDefault()
  var editForm = document.querySelector('form#new_comment_question')
  editForm.classList.remove('d-none')
  this.classList.add('d-none')
}
