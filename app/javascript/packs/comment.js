document.addEventListener('turbolinks:load', function() {
  let newQuestionCommentElement = document.querySelector('.btn_new_question_comment')
  let questionComments = document.querySelectorAll('a.delete_question_comment')

  if (newQuestionCommentElement) { newQuestionCommentElement.addEventListener('click', newCommentForm) }
  questionComments.forEach(comment => { comment.addEventListener('click', deleteQuestionComment) })
})

function newCommentForm(e) {
  e.preventDefault()
  var editForm = document.querySelector('form#new_comment_question')
  editForm.classList.remove('d-none')
  this.classList.add('d-none')
  document.getElementById('comment_body').value = ""
}

function deleteQuestionComment(e) {
  e.preventDefault()

  this.parentElement.remove()
}
